#!/bin/sh
SELECTION=&(fd .pdf | rofi -dmenu) && evince $SELECTION
