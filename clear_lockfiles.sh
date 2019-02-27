#!/bin/sh

# Copyright (c) 2019 Manfred Roiger <manfred.roiger@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# clear_lockfiles.sh
# Remove unwanted lockfiles in the Print Publisher checkin folder.
# If an InDesign Server job fails it can happen, that the job does not terminat
# gracefully and that lockfiles stay open in the checkin folder of Print
# Publisher.
# In most cases the file is still in use by InDesing Server and therefore the
# InDesign Server process must be killed before the file can be deleted.

# Print Publisher checkin folder and error folder
CHECKIN_FOLDER="/Volumes/KatalogEditor/AutokatID_V2/checkin"
# CHECKIN_FOLDER="/Users/manfred/github/scripts/checkin"
ERROR_FOLDER="/Volumes/KatalogEditor/AutokatID_V2/error"

# Extensions of lockfiles and InDesign documents
IDLK_EXT="idlk"
INDD_EXT="indd"

# Remove broken jobs represented by filenames that start with cifs
CIFS_FILES=$(ls ${CHECKIN_FOLDER} | grep -i cifs)
for FILE in ${CIFS_FILES}; do
  # Check if the file is still in use
  PID=$(lsof 2>/dev/null | grep ${FILE} | tail -1 | awk '{ print $2 }' )
  # Kill the process if applicable
  if [[ -n ${PID} ]]; then
    kill -9 ${PID}
  fi
  rm -f ${CHECKIN_FOLDER}/${FILE}
done

# Run until no more lockfiles are present
while true; do

  # Normally a stuck lockfile is the oldest file in the directory. If the
  # oldest file in the directory has a lockfile extension it should be a
  # candidate for removal
  OLDEST_LOCKFILE=$(ls -1rt ${CHECKIN_FOLDER} | head -1 | grep ${IDLK_EXT})
  if [[ -n ${OLDEST_LOCKFILE} ]]; then

    # Only remove if the lockfile is older than 10 minutes
    TEN_MINUTES=$(find ${CHECKIN_FOLDER}/${OLDEST_LOCKFILE} -cmin +10)

    if [[ -n ${TEN_MINUTES} ]]; then

      # Check if an InDesign Document still exists. If for any reason the file
      # is still there skip
      INDD_FILE=$(echo ${OLDEST_LOCKFILE} | cut -c2-18)
      INDD_EXISTS=$(ls ${CHECKIN_FOLDER} | grep -i ${INDD_FILE}.${INDD_EXT})
      if [[ -n ${INDD_EXISTS} ]]; then
        exit 1
      fi

      # Check if the file is still in use
      PID=$(lsof 2>/dev/null | grep ${OLDEST_LOCKFILE} | tail -1 | awk '{ print $2 }' )
      # Kill the process if applicable
      if [[ -n ${PID} ]]; then
        kill -9 ${PID}
      fi
      rm -f ${CHECKIN_FOLDER}/${OLDEST_LOCKFILE}
    else
      exit 0
    fi
  else
    exit 0
  fi
done
