This directory contains subdirectories, which correspond to individual TeX
formats. These subdirectories contain TeX source code templates, which
can be recognized by the `.tex` suffix, and a file named `COMMANDS`.

The TeX source code templates are documents that will be typeset as a part of
every test. Before being typeset, they are pre-processed as follows:

 1. Any occurance of the string `<TEST-SETUP-FILENAME>` is replaced with the
    name of the file containing the test setup TeX source code.
 2. Any occurance of the string `<TEST-INPUT-FILENAME>` is replaced with the
    name of the file containing the test markdown source code.
 3. Any line containing only `<TEST-INPUT-VERBATIM>` surrounded with optional
    whitespaces is replaced with the test markdown source code.

The `COMMANDS` file contains a newline-separated list of commands that will
be used to typeset the pre-processed TeX source code templates. Any occurance
of the string `<FILENAME>` in the commands is replaces with the name of the
pre-processed TeX source code template that is being typeset.
