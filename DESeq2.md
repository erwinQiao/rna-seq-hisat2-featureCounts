# DESeq2  

DESeq2 包是用于RNA-seq数据差异表达分析的R包。它基于edgeR包，并添加了额外的功能，如样本组信息校正、基因长度校正、基因表达量校正等。DESeq2包提供了多种函数和方法，用于 进行差异表达分析、可视化、统计检验等。

DESeq2寻找组间显著表达变化的基因，以解释基因表达水平的变化对生物功能的变化最直接的办法就行进行转录组测序和定量  

## 原理  

所谓的差异分析实际上是指通过假设检验来判断两组数据是否存在显著差异，有参数检验（总体分布已知）和非参数检验（总体分布未知）两种方式，显然，对于分布已知的数据，运用参数检验的结果会更准确些。因此在进行表达差异分析的时候，我们会假定表达数据符合某一个特定的分布，然后在使用参数检验的方式进行假设检验。  

主要是应用负二项分布模型来估计基因表达的差异。原因是count和基因数分布不是正太分布，count数量少，但是分布范围广，非正态分布，目前的观点认为，负二项分布在拟合RNA-seq的count数分布上表现最佳，因为RNA-seq counts数还具有这样的分布规律  

随着基因表达量的增加，基因count数分布的方差快速增加，低表达基因中count数分布的方法大小不一(方差异质性)，泊松分布和二项式分布表示不行，还是得用负二项分布来拟合  

### 泊松分布  

Poisson分布，是一种统计与概率学里常见到的离散概率分布，由法国数学家西莫恩·德尼·泊松（Siméon-Denis Poisson）在1838年时发表。泊松分布的参数λ是单位时间(或单位面积)内随机事件的平均发生次数。 泊松分布适合于描述单位时间内随机事件发生的次数。

1. 泊松分布是一种描述和分析稀有事件的概率分布。要观察到这类事件，样本含量必须很大  
2. λ是泊松分布所依赖的唯一参数。λ值愈小，分布愈偏倚，随着λ增大，分布趋于对称  
3. 当 λ=20时分布泊松分布接近于正态分布；当λ=50时，可以认为泊松分布呈正态分布。 在实际工作中，当20时就可以用正态分布来近似地处理泊松分布的问题。  

### 伯努利试验  

伯努利试验（Bernoulli trial，或译为白努利试验）是只有两种可能结果（“成功”或“失败”）的单次随机试验，即对于一个随机变量X而言  

Pr[X=1] = p  
Pr[X=0] = 1-p  

一个伯努利过程（Bernoulli process）是由重复出现独立但是相同分布的伯努利试验组成，例如抛硬币十次，而此时呈现之结果将呈现二项分布。  

### 二项分布  

二项分布（英语：Binomial distribution）是n个独立的是/非试验中成功的次数的离散概率分布，其中每次试验的成功概率为p。这样的单次成功/失败试验又称为伯努利试验。实际上，当n=1时，二项分布就是伯努利分布。二项分布是显著性差异的二项试验的基础  
\[ P(X = k) = \binom{n}{k} p^k (1 - p)^{n - k} \]  

- \( n \) is the number of trials,
- \( k \) is the number of successes,
- \( p \) is the probability of success on a single trial,
- \( \binom{n}{k} \) is the binomial coefficient, representing the number of ways to choose \( k \) successes from \( n \) trials.

概率密度函数的系数：\[ \binom{n}{k} = \frac{n!}{k!(n-k)!} \]  
C(n,k)  

**概率质量函数**和**概率密度函数**不同之处在于：概率质量函数是对离散随机变量定义的，本身代表该值的概率；概率密度函数是对连续随机变量定义的，本身不是概率，只有对连续随机变量的概率密度函数在某区间内进行积分后才是概率。  

### 负二项分布  

负二项分布（Negative binomial distribution）是统计学上一种描述在一系列独立同分布的伯努利试验中，成功次数达到指定次数（记为r）时失败次数的离散概率分布。“负二项分布”与“二项分布”的区别在于：“二项分布”是固定试验总次数N的独立试验中，成功次数k的分布；而“负二项分布”是所有到r次成功时即终止的独立试验中，失败次数k的分布。  

## DESeq2步骤  

DESeq2对原始reads进行建模，使用标准化因子(scale factor)来解释库深度的差异。然后，DESeq2估计基因的离散度，并缩小这些估计值以生成更准确的离散度估计，从而对reads count进行建模。最后，DESeq2拟合负二项分布的模型，并使用Wald检验或似然比检验进行假设检验。  

### 1.标准化  

DEseq2的基因标准化原理：DEseq有自己的一套count标准化程序：其实TPM之类的标准化方法虽然解决了基因长度和测序深度的影响的问题，但还是不能解决一个问题：那就是测序文库组成不同造成的差异 这种差异的来源是一个基因被敲减了，完全没表达了，因而影响到了其他基因。  

**RPKM**  
RPKM的计算逻辑其实很简单，我们刚才已经说过，测序Read数是会受到基因长度和测序深度影响的，所以RPKM就是为了消除这两项偏差,既然受到基因长度影响，那么将测序Read数除以基因长度就OK了，而受到测序深度影响，那么再将Read数除以总Read数进行标准化也就消除了测序深度的影响。  

只不过这里基因长度是用kb表示的，所以RPKM中是K，Kilobase。而总Read数太大了，直接除以这个数字就会使得标准化出来的Read数出现太多的小数，所以为了美观，一般都是除以以百万为单位的总Read数，举例来说，假定一次RNA-seq的总Read数为2*10^7，那么在进行Read标准化的时候，并不是直接除以这个数值，而是除以20，因为2*10^7 = 20*10^6 = 20M，所以RPKM中才是M，Million。  

```{text}
全名为：
    Reads Per Kilobase of exon model per Million mapped reads.

计算方式为：
    RPKM= total exon reads/ (mapped reads (Millions) * exon length(KB))；
    其中，
        total exon reads：某个样本mapping到特定基因的外显子上的所有的reads；
        mapped reads (Millions) :某个样本的所有reads总和；
        exon length(KB)：某个基因的长度（外显子的长度的总和，以KB为单位）.
```

标准化处理主要是为了解决两个问题：  

- 文库大小造成两组数据之间存在的差异  
- 测序深度造成两组数据之间存在的差异  

具体标准化的过程如下：  

1. 计算所有样本的同一基因的对数均值，然后去除对数均值为Inf的值（read count为0的）。取对数的目的是减弱异常值的影响，使得数据分布更加平滑; 剔除reads数为0的基因是为了留下稳定表达的基因。
实际上，这一步是把在一个或多个样本中存在零表达的基因剔除。假定本实验是在比较不同组织细胞如肝细胞和脾细胞的表达量差异，那么这一步会剔除掉组织特异性表达的基因，而只保留管家基因——在不同细胞中都或多或少会表达的基因。  

2. 使用对数矩阵分别减去对应基因的对数均值，得到新的矩阵  

3. 对于上个步骤得到的新的矩阵，计算每个样本的中位数（均值比较容易受异常值的影响，但中位数对异常值则不敏感） ,然后使用该中位数取真数(求e)，得到的结果作为该样本的标准化因子。  

4. 原始reads数矩阵分别除以标准化因子得到最终标准化的矩阵  
得到的标准化的表达矩阵就可以使用负二项分布的统计模型进行假设检验了 得到一个近似为同方差的值矩阵  

### 2.计算离散度  

我们需要通过计算基因平均表达的差异找出差异基因，同时考虑组内方差。DEseq2使用dispersion代替variation 离散度（dispersion）与表达量成负相关，与方差成正相关 Dispersion可以反应同一平均表达量下基因的离散程度。  

用dispersion合并了方差和表达量，后面我们的统计学检验都是基于dispersion 虽然所有基因都有不同的dispersion，但是所有基因会形成一个规律的分布，而这个分布就能使用负二项分布模型进行线性拟合  

### 3. shrink dispersion  

压缩离散度 拟合的效果很大程度影响了差异基因的鉴定。为了完成更棒的拟合，我们还需要把dispersion 压缩一下  

DESeq2使用离散度(dispersion)作为方差的度量方式，离散度既可以解释基因表达值的方差也可以解释基因的平均表达值。其具体公式为：Var = μ + α*μ^2。其中Var表示方差，μ表示均值，α表示离散度。因此我们可以得到这么一个关系  

DESeq2假定基因的表达量符合负二项分布，有两个关键参数，总体均值和离散程度α值。这个α值衡量的是均值和方差之间的关系。  

#### 4. Fit curve to gene-wise dispersion estimates  

DESeq2的第三步就是根据基因的离散度拟合一个曲线。那么为什么要做拟合呢？不同的基因生物学重复中存在不同的方差，但是，在所有的基因中，将会有一个合理的离散分布。  

这个曲线如下图红线所示，其中红线的横坐标是基因的表达强度，纵坐标是理论离散值。而每一个黑点的横坐标是基因的平均表达水平，纵坐标是经过最大似然估计的离散值。  

#### 5. Shrink gene-wise dispersion estimates toward the values predicted by the curve  

有了拟合曲线，接下来就是对基因表达水平的离散度进行矫正，即：将基因的实际离散度向红线收缩(shrink)。当样本量较小时，该曲线可以让我们更为准确的识别差异表达基因。既然知道要将基因的离散度向红色曲线收缩，那么收缩多少比较合适呢？有两点需要考虑  

1. 基因的离散度距离红色曲线的距离  
2. 样本量(样本量越大，则收缩的越少)  

这种方法在差异表达分析时，可以极大的减少数据的假阳性。离散度较低的基因朝着理论值收缩，从而得到一个更为准确的离散值。而那些离散度较高的基因，则不能无脑朝着理论值收缩。  

#### 6. GLM fit for each gene  

#### 7. 差异分析表达  

test可以是Wald significance tests或likelihood ratio test（似然比检验），on the difference in deviance between a full and reduced model formula。  

获得分析结果，包含6列：baseMean、log2FC、lfcSE、stat、pvalue、padj  

## DESeq2计算流程  

在使用DESeq2进行基因表达差异分析之前，最重要的是明确我们的研究目的，了解数据中的变异来源。一旦我们了解了数据的主要变异来源，就可以在分析之前提前移除它们，或者通过将这些变量包含在统计模型的公式中对它们进行分析。  

如果我们知道性别是数据中一个比较显著的变异来源，那么我们就需要将sex写入到统计模型的公式中。公式应该包含数据中的所有因素，这些因素解释了数据中主要的变化来源，其中公式中的最后一个因素，应为我们最为关注的因素  

我们想要知道treatment的影响，其中sex和age是主要的变异来源，那么我们的公式则应该为design <- ~sex + age + treatment  

### 1. 数据预处理  

假设现在有一个表达矩阵cts，样本信息coldata，其中的design 表示怎样设计样本的模型(这里表示既考虑样本条件condition，又考虑了批次效应batch，并且这两项都要是coldata 的因子型变量)  

DESeq2可以和一些上游的定量软件兼容，比如：
常规的countshi使用DESeqDataSetFromMatrix  
如果用Salmon、Sailfish、kallisto 得到表达矩阵，那么就可以用DESeqDataSetFromTximport 导入  
如果有htseq得到的，就利用DESeqDataSetFromHTSeq  
如果有RangedSummarizedExperiment 得到的，利用DESeqDataSet, RangedSummarizedExperiment  

```{r}
# 这里演示的就是普通的矩阵导入
dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design= ~ batch + condition)
dds <- DESeq(dds)
resultsNames(dds) # lists the coefficients
res <- results(dds, name="condition_trt_vs_untrt")
# or to shrink log fold changes association with condition:
res <- lfcShrink(dds, coef="condition_trt_vs_untrt", type="apeglm")
```

### 2. 差异表达分析  



 
## PCA  

对于RNA-seq raw counts，方差随均值增长。如果直接用size-factor-normalized read counts：counts(dds, normalized=T) 进行主成分分析，结果通常只取决于少数几个表达最高的基因，因为它们显示了样本之间最大的绝对差异。为了避免这种情况，一个策略是采用the logarithm of the normalized count values plus a small pseudocount：log2(counts(dds2, normalized=T) +1)。但是这样，有很低counts的基因将倾向于主导结果。作为一种解决方案，DESeq2为counts数据提供了stabilize the variance across the mean的转换。其中之一是regularized-logarithm transformation or rlog2。对于counts较高的基因，rlog转换可以得到与普通log2转换相似的结果。然而，对于counts较低的基因，所有样本的值都缩小到基因的平均值。  

用于绘制PCA图或聚类的数据可以有多种：counts、CPM、log2(counts+1)、log2(CPM+1)、vst、rlog等。  