# 遇到的问题积累

## SyntaxError

1. Not all output, log and benchmark files of rule fastqc contain the same wildcards. This is crucial though, in order to avoid that two or more jobs write to the same file.  

    问题：这个问题主要就是通配符的重复使用或者是占用，导致出现不能识别，从而报错  

    方法：解决通配符的使用问题，尤其是output和benchmark之间的冲突，output本质上是输出的结果文件，不能使用output作为输出的文件夹,主要是检查log的通配符，output通配符，input通配符  

2. Invalid syntax. Perhaps you forgot a comma?  

    问题：拼写错误或者是smk中语法错误导致的报错，常见的是缺少逗号，引号位置错误  
    处理：仔细检查语句  

3. MissingOutputException in rule xxx, Shutting down, this might take some time. Exiting because a job execution failed. Look above for error message  

    问题：还是写法出现了错误，基本上肯定是没有写对，或者逻辑上出现了bug，需要按照问题甄别  
    处理：检查包输出的文件格式和名称，有的包只能输出到文件夹，名称都是特定的，所以output设定好之后需要去核实，否则会出现匹配不上，然后结果输出不到自定义的output上，导致程序的中断  

4. Colon expected after keyword resources.  

    问题：语法写错，尤其注意通配符的是否少些或者写错  

5. MissingInputException in rule multiqc  

    问题：这种情况一般是缺少输入文件，有可能上面的output作为下面的input，文件名发生了错位
    解决：需要仔细检查，核对  

https://github.com/niekwit/rna-seq-salmon-deseq2/tree/main  

https://github.com/snakemake-workflows/rna-seq-star-deseq2/tree/master/workflow  

https://github.com/matrs/Quality_control/blob/master/rules/qc.smk  

https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/fastqc.html  