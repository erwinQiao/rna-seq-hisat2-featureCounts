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

6. rule all的理解

    首先要了解snakemake的运行逻辑，是由结果反向推倒输入文件，而输出文件必须有输入的需求才能保留下来，所以当你output的文件没有后续的input的时候，就需要使用rule all，input所需的文件  

7. MissingRuleException: No rule to produce workflow/Snakefile (if you use input functions make sure that they don't raise unexpected exceptions).  

    问题：没有输出的需求，所以没法运行  
    解决；填写输出文件  

8. IndentationError in file <tokenize>, line 64  
    问题： 缩进出现问题，其实是格式问题  
    解决：检查文件中缩进的情况  

9. MissingInputException in rule hisat2_ensembl_index  
    问题： 输入文件超预期  
    解决： 仔细检查input的文件是文件还是字符串，注意“ ”的使用  

10. MissingOutputException in rule hisat2_ensembl_index in file /home/erwin/snakemakev8/workflow/rules/hisat2_index.smk, line 5: 
    问题：缺少输出文件

11. raise AttributeError(AttributeError): invalid name for input, output, wildcard, params or log: count is reserved for internal use  

    问题：分配错误，意思是有内置的名称被占用，这个是count被占用，找到这个问题比较难  
    解决：改名字，解决是容易的，但是发现比较难  





https://github.com/niekwit/rna-seq-salmon-deseq2/tree/main  

https://github.com/snakemake-workflows/rna-seq-star-deseq2/tree/master/workflow  

https://github.com/matrs/Quality_control/blob/master/rules/qc.smk  

https://snakemake-wrappers.readthedocs.io/en/stable/wrappers/fastqc.html  