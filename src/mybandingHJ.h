/*
 *    This file is part of HMMoC 1.3, a hidden Markov model compiler.
 *    Copyright (C) 2007 by Gerton Lunter, Oxford University.
 *
 *    HMMoC is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    HMMOC is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with HMMoC; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
\*/
#include <iostream>

#include "alignerHJ.h"

using std::min;
using std::max;

// Implements a traversal of the dynamic programming table along a diagonal band.
// The band should remain (diagonally) connected even if iWidth==1, and the forward
// and backward iterations must visit the same sites - these two requirements made the
// implementation slightly tricky.

class MyBanding : Banding<2> {

 private:

  int iLen0, iLen1;
  int iWidth;
  Position pos;
  int iLastRow;

  int diagonal(int p1) { return (p1 * iLen0 + iLen1/2) / iLen1; }

 public:

  MyBanding( int iLen0, int iLen1, int iWidth ) : iLen0(iLen0), iLen1(iLen1), iWidth(iWidth) {}

  Position& forwardIterator() {

    pos[0] = pos[1] = 0;
    iLastRow = iLen0;
    return pos;

  }

  Position& backwardIterator() {

    pos[0] = iLen0;
    pos[1] = iLen1;
    iLastRow = 0;
    return pos;

  }

  bool hasNextForward() {

    if (pos[0] < iLen0 && pos[0] < (iWidth-1)/2 + max( diagonal(pos[1]+1)-1, diagonal(pos[1]))) {
      ++pos[0];
      return true;
    }
    if (pos[1]<iLen1) {
      ++pos[1];
      pos[0] = max(0, diagonal(pos[1]) - iWidth/2);
      return true;
    }
    return false;
  }

  bool hasNextBackward() {

    if (pos[0] > 0 && pos[0] > diagonal(pos[1]) - iWidth/2) {
      --pos[0];
      return true;
    }
    if (pos[1]>0) {
      --pos[1];
      pos[0] = min(iLen0, (iWidth-1)/2 + max( diagonal(pos[1]+1)-1, diagonal(pos[1])));
      return true;
    }
    return false;
  }

  bool lastColumnEntry() {

    return pos[0] == iLastRow;

  }

  void warning() {

    cout << "Warning - out of bounds at position (" << pos[0] << "," << pos[1] << ")" << endl;

  }

};
