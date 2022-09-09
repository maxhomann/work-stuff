FILE1="libs/common/commons-cli-1.4.jar"
FILE2="target/jmx-jpos-server-assembly-1.103.0-SNAPSHOT-mock/dep/commons-cli-1.4.jar"

for file in libs/common/*; do
    otherFile="target/jmx-jpos-server-assembly-1.103.0-SNAPSHOT-mock/dep"/$(basename "${file}")
    echo "${file}"
    echo "${otherFile}"
    if [ -f "${otherFile}" ]; then
        echo "----------------------- Comparing ... "
        diff \
            <(unzip -vqq "${file}" | awk '{$2=""; $3=""; $4=""; $5=""; $6=""; print}' | sort -k3) \
            <(unzip -vqq "${otherFile}" | awk '{$2=""; $3=""; $4=""; $5=""; $6=""; print}' | sort -k3)
    else
        echo "ERR: ${otherFile} not found"
    fi
done
