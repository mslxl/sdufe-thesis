demo:
    latexmk --xelatex demo.tex

dev:
    #!/usr/bin/env bash
    while [[ 1 ]] ; do
        just demo
        echo "Press [Enter] to recompile..."
        read
        clear
    done

clean:
    rm *.aux
    rm *.fdb_latexmk
    rm *.fls
    rm *.log
    rm *.xdv


