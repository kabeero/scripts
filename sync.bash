#!/bin/bash

# need a script to sync ion <-> fluorish <-> flux

rsync -Pa 			~/Documents/scripts/ 	fluorish.io:work/scripts/flux/
rsync -Pa 			~/Documents/school/ 	fluorish.io:work/school/
rsync -Pa --delete	~/Work/trade 			fluorish.io:work/

#rsync -Pa --delete	~/documents/bmw	 		fluorish.io:work/
#rsync -Pa --delete	~/documents/insurance	fluorish.io:work/
#rsync -Pa --delete	~/documents/invoice	 	fluorish.io:work/
#rsync -Pa --delete	~/documents/taxes	 	fluorish.io:work/
#rsync -Pa --delete	~/documents/xray	 	fluorish.io:work/
#rsync -Pa --delete	~/documents/labcorp/pmd	fluorish.io:work/

