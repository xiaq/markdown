#!/bin/sh
# Run a test for each testfile passed as an argument. If a testfile does not
# contain the expected test result, generate one.
trap 'rm -rf build/' INT
for TESTFILE; do
  printf 'Testfile %s\n' $TESTFILE
  for FORMAT in templates/*/; do
    printf '  Format %s\n' $FORMAT
    for TEMPLATE in ${FORMAT}*.tex; do
      printf '    Template %s\n' $TEMPLATE
      sed 's/<FILENAME>/test.tex/g' <$FORMAT/COMMANDS |
      while read COMMAND; do
        printf '      Command %s\n' "$COMMAND"

        # Set up the testing directory.
        rm -rf build/ && mkdir build/ &&
        cp support/* $TESTFILE build/ &&
        cd build/ &&
        sed -r '/^\s*<<<\s*$/{x;q}' \
          <${TESTFILE##*/} >test-setup.tex &&
        sed -rn '/^\s*<<<\s*$/,/^\s*>>>\s*$/{/^\s*(<<<|>>>)\s*$/!p}' \
          <${TESTFILE##*/} >test-input.md &&
        sed -n '/^\s*>>>\s*$/,${/^\s*>>>\s*$/!p}' \
          <${TESTFILE##*/} >test-expected.log &&
        sed 's/<TEST-SETUP-FILENAME>/test-setup.tex/g;
             s/<TEST-INPUT-FILENAME>/test-input.md/g' <../$TEMPLATE |
          (IFS=; while read -r LINE; do
            if printf '%s\n' "$LINE" | grep -q '^\s*<TEST-INPUT-VERBATIM>\s*$'; then
              cat test-input.md
            else
              printf '%s\n' "$LINE"
            fi
          done) >test.tex &&

        # Run the test, filter the output and concatenate adjacent lines.
        eval $COMMAND >/dev/null &&
        sed -nr '/^\s*TEST INPUT BEGIN\s*$/,/^\s*TEST INPUT END\s*$/{
          /^\s*TEST INPUT (BEGIN|END)\s*$/!H
          /^\s*TEST INPUT END\s*$/{s/.*//;x;s/\n//g;p}
        }' <test.log >test-actual.log &&

        # If the testfile does not contain an expected outcome, use the current
        # outcome and update the testfile.
        if ! grep -q '^\s*>>>\s*$' <${TESTFILE##*/}; then
          cp test-actual.log test-expected.log &&
          (cat ${TESTFILE##*/} && printf '>>>\n' &&
            cat test-expected.log) >../$TESTFILE &&
          printf '      Added the expected test outcome to the testfile.\n'
        fi &&

        # Compare the expected outcome against the actual outcome.
        diff test-expected.log test-actual.log &&
#         || (sed -n '1,/^\s*>>>\s*$/p' <${TESTFILE##*/} && 
#             cat test-actual.log) >../$TESTFILE &&

        # Clean up the testing directory.
        cd .. && rm -rf build/ || { printf 'ERROR\n'; exit 1; }

      done || exit $?
    done
  done
done
