#! /bin/bash

# Create archive or exit if command fails
set -eu

printf "\n📦 Creating %s archive...\n" "$INPUT_TYPE"

if [ "$INPUT_DIRECTORY" != "." ] 
then
  cd "$INPUT_DIRECTORY"
fi

# Split list-type inputs into arrays safely (word-split on whitespace only, no glob/metachar expansion)
IFS=' ' read -ra CUSTOM_ARGS <<< "$INPUT_CUSTOM"
IFS=' ' read -ra EXCLUSION_LIST <<< "$INPUT_EXCLUSIONS"
IFS=' ' read -ra RECURSIVE_EXCLUSION_LIST <<< "$INPUT_RECURSIVE_EXCLUSIONS"

if [ "$INPUT_TYPE" = "zip" ] 
then
  if [ "$RUNNER_OS" = "Windows" ]
  then
    if [ -z "$INPUT_EXCLUSIONS" ] 
    then
      7z a -tzip "$INPUT_FILENAME" "$INPUT_PATH" "${CUSTOM_ARGS[@]}" || { printf "\n⛔ Unable to create %s archive.\n" "$INPUT_TYPE"; exit 1;  }
    else
      EXCLUSIONS=()

      for EXCLUSION in "${EXCLUSION_LIST[@]}"
      do
        EXCLUSIONS+=("-x!$EXCLUSION")
      done

      for EXCLUSION in "${RECURSIVE_EXCLUSION_LIST[@]}"
      do
        EXCLUSIONS+=("-xr!$EXCLUSION")
      done

      7z a -tzip "$INPUT_FILENAME" "$INPUT_PATH" "${EXCLUSIONS[@]}" "${CUSTOM_ARGS[@]}" || { printf "\n⛔ Unable to create %s archive.\n" "$INPUT_TYPE"; exit 1;  }
    fi
  else
    if [ -z "$INPUT_EXCLUSIONS" ] 
    then
      zip -r "$INPUT_FILENAME" "$INPUT_PATH" "${CUSTOM_ARGS[@]}" || { printf "\n⛔ Unable to create %s archive.\n" "$INPUT_TYPE"; exit 1;  }
    else
      zip -r "$INPUT_FILENAME" "$INPUT_PATH" -x "${EXCLUSION_LIST[@]}" "${CUSTOM_ARGS[@]}" || { printf "\n⛔ Unable to create %s archive.\n" "$INPUT_TYPE"; exit 1;  }
    fi
  fi
elif [ "$INPUT_TYPE" = "tar" ] || [ "$INPUT_TYPE" = "tar.gz" ] 
then
  if [ -z "$INPUT_EXCLUSIONS" ] 
  then
    tar -zcvf "$INPUT_FILENAME" "$INPUT_PATH" "${CUSTOM_ARGS[@]}" || { printf "\n⛔ Unable to create %s archive.\n" "$INPUT_TYPE"; exit 1;  }
  else
    EXCLUSIONS=()

    for EXCLUSION in "${EXCLUSION_LIST[@]}"
    do
      EXCLUSIONS+=("--exclude=$EXCLUSION")
    done

    tar "${EXCLUSIONS[@]}" -zcvf "$INPUT_FILENAME" "$INPUT_PATH" "${CUSTOM_ARGS[@]}" || { printf "\n⛔ Unable to create %s archive.\n" "$INPUT_TYPE"; exit 1;  }
  fi
else
  printf "\n⛔ Invalid archiving tool.\n"; exit 1;
fi

printf "\n✔ Successfully created %s archive.\n" "$INPUT_TYPE"
