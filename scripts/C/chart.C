/** \file chart.C
 *
 *  `chart.C' is part of the Badger software package, and it aims to check if Markov chain converges by using tree samples.   
 *
 * Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009, 2010 by Bret Larget & Don Simon
 *
 * License: GPLv3+
 */

#include <iostream>
#include <iomanip>
#include <string>
#include <sstream>
#include <vector>
#include <fstream>

#define TABLE_SIZE 50000

using namespace std;

void readFile(string filename, int size, int i, vector<string> &clades, double table[][TABLE_SIZE], int &max)
{
  ifstream f(filename.c_str());
  if(f.fail()) {
    cerr <<"Error: Cannot open file " << filename << "." << endl;
    exit(1);
  }

  for(int j=0;j<clades.size();j++)
    table[i][j] = 0;

  string buf;

  while(getline(f,buf) 
	&& buf != "************************ Common Clades ************************")
    {}

  string s;
  int x;
  double p;

  getline(f,buf);
  while(getline(f,buf)) {
    istringstream st(buf);
    st >> x >> p >> s;
    if(s.length()>max)
      max = s.length();
    int n = find(clades.begin(),clades.end(),s) - clades.begin();
    if(n==clades.size()) {
      clades.push_back(s);
      for(int k=0;k<size;k++)
	table[k][n] = 0;
    }
    table[i][n] = p;
  }
  f.close();
}

int main(int argc, char *argv[])
{
  double table[argc-1][TABLE_SIZE];
  vector<string> clades;
  int max=0;

  for(int i=0;i<argc-1;i++)
    readFile(argv[i+1],argc-1,i,clades,table,max);
  
  cout.setf(ios::fixed, ios::floatfield);
  cout.setf(ios::showpoint);

  for(int i=0;i<clades.size();i++) {
    cout << setw(max) << left << clades[i].substr(0,max) << right;
    double min=1,max=0;
    for(int j=0;j<argc-1;j++) {
      if(table[j][i]>max)
	max = table[j][i];
      if(table[j][i]<min)
	min = table[j][i];
      cout << " " << setprecision(3) << table[j][i];
    }
    cout << " ";
    for(int i=1;i<=(max-min)/.05;i++)
      cout << "*";
    cout << endl;
  }
}

