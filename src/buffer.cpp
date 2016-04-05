//submitted by: Stephen Sturdevant, Xuyi Ruan, Yunhe Liu
/**
 * @author See Contributors.txt for code contributors and overview of BadgerDB.
 *
 * @section LICENSE
 * Copyright (c) 2012 Database Group, Computer Sciences Department, University of Wisconsin-Madison.
 */

#include <memory>
#include <iostream>
#include "buffer.h"
#include "exceptions/buffer_exceeded_exception.h"
#include "exceptions/page_not_pinned_exception.h"
#include "exceptions/page_pinned_exception.h"
#include "exceptions/bad_buffer_exception.h"
#include "exceptions/hash_not_found_exception.h"

namespace badgerdb { 

BufMgr::BufMgr(std::uint32_t bufs)
	: numBufs(bufs) {
	bufDescTable = new BufDesc[bufs];

  for (FrameId i = 0; i < bufs; i++) 
  {
  	bufDescTable[i].frameNo = i;
  	bufDescTable[i].valid = false;
  }

  bufPool = new Page[bufs];

	int htsize = ((((int) (bufs * 1.2))*2)/2)+1;
  hashTable = new BufHashTbl (htsize);  // allocate the buffer hash table

  clockHand = bufs - 1;
}


BufMgr::~BufMgr() {
    // Clean up
    delete hashTable;
    for (FrameId i = 0; i < numBufs; i++) {
        if (bufDescTable[i].dirty) {
            bufDescTable[i].file->writePage(bufPool[i]);
            bufDescTable[i].dirty = false;
        }
    }
    delete [] bufDescTable;
    delete [] bufPool;
}

void BufMgr::advanceClock() {
    // Just advance the clock hand, not much more to it!
    clockHand = (clockHand + 1) % numBufs; 
}

void BufMgr::allocBuf(FrameId & frame) {
    // First let's do an inefficient check to see if all pages are pinned
    bool hasUnpinned = false;
    for (FrameId i = 0; i < numBufs; i++)
        if (bufDescTable[i].pinCnt == 0)
            hasUnpinned = true;

    // Result is that all pages are in fact pinned :( throw exception
    if (!hasUnpinned)
        throw BufferExceededException();

    // Now we do clock algorithm since we know there's at least 1 unpinned pg
    bool found = false;
    BufDesc* curr;
    while (!found) {
        // Get current BufDesc
        this->advanceClock();
        curr = &bufDescTable[clockHand];
        
        // If a page isn't valid(present), we can choose this one!
        if (!curr->valid) {
            found = true;
            continue;
        }

        // Check refbit
        if (curr->refbit) {
            curr->refbit = false;
            continue;
        }
        
        // Check page pin
        if (curr->pinCnt > 0)
            continue;

        // Current page can be used and is valid, so remove hash entry
        found = true;
        hashTable->remove(curr->file, curr->pageNo);
    }

    // Write page to disk only when dirty 
    if (curr->dirty) {
        curr->file->writePage(bufPool[clockHand]);
        curr->dirty = false;
    } 

    // Set frame parameter
    frame = clockHand;
}

	
void BufMgr::readPage(File* file, const PageId pageNo, Page*& page) {
    FrameId frameNo;
    try {
        // See if already in hashtable, if so, return relevant info
        hashTable->lookup(file, pageNo, frameNo);
        bufDescTable[frameNo].refbit = true;
        bufDescTable[frameNo].pinCnt++;
    } catch (HashNotFoundException e) {
        // Make our own entry in the hash table after finding open frame
        Page tmpPage = file->readPage(pageNo);
        this->allocBuf(frameNo);
        bufPool[frameNo] = tmpPage; 
        hashTable->insert(file, pageNo, frameNo);
        bufDescTable[frameNo].Set(file, pageNo);
    }
    page = &bufPool[frameNo];
}


void BufMgr::unPinPage(File* file, const PageId pageNo, const bool dirty) {
    try {
        // Find page & decrement reference count
        FrameId frameNo;
        hashTable->lookup(file, pageNo, frameNo);
        if (dirty)
            bufDescTable[frameNo].dirty = true;
        if (bufDescTable[frameNo].pinCnt > 0)
            bufDescTable[frameNo].pinCnt--;
        else
            throw PageNotPinnedException(file->filename(), pageNo, frameNo);
    } catch (HashNotFoundException e) {
        // I don't think we have to do anything
    }
}

void BufMgr::flushFile(const File* file) {
    // Flush file to disk
    for (FrameId i = 0; i < numBufs; i++) {
        if (bufDescTable[i].file == file) {
            if (bufDescTable[i].pinCnt > 0)
                throw PagePinnedException(file->filename(), 
                                          bufDescTable[i].pageNo, i);
            else if (!bufDescTable[i].valid)
                throw BadBufferException(i, bufDescTable[i].dirty,
                                         bufDescTable[i].valid,
                                         bufDescTable[i].refbit);
            else {
                if (bufDescTable[i].dirty) {
                    bufDescTable[i].file->writePage(bufPool[i]);
                    bufDescTable[i].dirty = false;
                }

                hashTable->remove(file, bufDescTable[i].pageNo);
                bufDescTable[i].Clear();
            }
        }
    }
}

void BufMgr::allocPage(File* file, PageId &pageNo, Page*& page) {
    // Allocate a new page, set pageNo, and then find a free frame
    Page tmp_page = file->allocatePage();
    pageNo = tmp_page.page_number();

    // Find available frame
    FrameId frameNumber;
    this->allocBuf(frameNumber);
    bufPool[frameNumber] = tmp_page;
    
    // Insert into hash table
    hashTable->insert(file, pageNo, frameNumber);

    // Update bufDescTable & return result
    bufDescTable[frameNumber].Set(file, pageNo);
    page = &bufPool[frameNumber];
}

void BufMgr::disposePage(File* file, const PageId pageNo) {
    // Remove specified page from file
    try {
        FrameId frameNo;
        hashTable->lookup(file, pageNo, frameNo);
        bufDescTable[frameNo].Clear();
        hashTable->remove(file, pageNo);
    } catch (HashNotFoundException e) {
    }
    file->deletePage(pageNo);
}

void BufMgr::printSelf(void) {
  BufDesc* tmpbuf;
	int validFrames = 0;
  
  for (std::uint32_t i = 0; i < numBufs; i++)
	{
  	tmpbuf = &(bufDescTable[i]);
		std::cout << "FrameNo:" << i << " ";
		tmpbuf->Print();

  	if (tmpbuf->valid == true)
    	validFrames++;
  }

	std::cout << "Total Number of Valid Frames:" << validFrames << "\n";
}

}
