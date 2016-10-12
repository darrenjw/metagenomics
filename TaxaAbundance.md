# Introduction to taxa abundance data in R

### Original latex...

\documentclass[mathserif,handout]{beamer}
%\documentclass{beamer}
\usetheme{Warsaw}
\usecolortheme{seahorse}
\usecolortheme{orchid}
\usepackage{amsmath,verbatim}
\usepackage{listings}
\usepackage[english]{babel}
\usepackage{movie15}
\setbeamercovered{transparent}

\newcommand{\Deltap}{\ensuremath{\Delta^{\!+}}}
\newcommand{\trans}{\ensuremath{{}^\mathrm{T}}}
\newcommand{\eps}{\varepsilon}
\newcommand{\ex}[1]{{\operatorname{E}\left[#1\right]}}
\newcommand{\var}[1]{{\operatorname{Var}\left[#1\right]}}
\newcommand*{\approxdist}{\mathrel{\vcenter{\offinterlineskip
\vskip-.25ex\hbox{\hskip.55ex$\cdot$}\vskip-.25ex\hbox{$\sim$}
\vskip-.5ex\hbox{\hskip.55ex$\cdot$}}}}

% \lstMakeShortInline[language=myR]¬

\lstdefinelanguage{myR} 
{
   language=R,
   otherkeywords={read.table, set.seed, head},
   deletekeywords={url,codes, t, dt, Call, formula,Q, R, on,by,hat,is,
col, set,start,end,deltat,zip},
   sensitive=true,
   breaklines=true,
   morecomment=[l]{\#},
   morestring=[b]",
   morestring=[b]',
   basicstyle =\ttfamily\small,
   keywordstyle=\bfseries,
   showtabs=false,
   showstringspaces=false,
   literate= {~}{$\sim$}{2},
   numberstyle=\sffamily\scriptsize,
   stepnumber=2
 }




\title{Analysis of taxa abundance data}
\author[Darren Wilkinson --- EBI, 2/12/2015]{\textbf{\large Darren 
Wilkinson} \\
\alert{\url{http://tinyurl.com/darrenjw}}\\
School of Mathematics \& Statistics, \\
Newcastle University, UK}
\date{Exploiting Metagenomics\\EBI, Hinxton\\2nd December, 2015}

\begin{document}

\section{Introduction}

\frame{\titlepage}

\frame{
\frametitle{Introduction}
\begin{itemize}
\item Using standard tools for processing sequencing data derived from metagenomic samples (such as the QIIME pipeline), it is possible to summarise taxonomic diversity in terms of the taxa present in the samples together with counts representing relative species abundance
\item Statistical concepts, models and algorithms from population ecology can be used to try to answer some important questions about the community from which the sample was taken:
  \begin{itemize}
  \item What was the true diversity of the population sampled, and what distributional form did the true taxa abundance distribution take?
  \item Is the distribution consistent with neutral theories of evolution?
  \item How much more sequencing would be required in order to sample a given required fraction of the true diversity of the sampled population?
  \end{itemize}
\end{itemize}
}

\section{The R language}

\frame{
\frametitle{The R language for statistical computing}
\begin{itemize}
\item R is a language for statistical computing, modelling, data analysis and visualisation --- \alert{\url{www.r-project.org}}
\item It is free, open source and cross-platform
\item There are thousands for packages for R, managed in a mirrored repository, known as CRAN --- \alert{\url{cran.r-project.org}}
\item Bioconductor is another R repository focussing specifically on high-throughput genomic data, containing over one thousand packages --- \alert{\url{www.bioconductor.org}}
\end{itemize}
It is possible to analyse raw sequencing data using Bioconductor packages such as \alert{ShortRead}, but that is not the subject of this talk...
}

\frame{
\frametitle{R packages for analysis of species diversity}
There are many R packages in CRAN for modelling and analysis of species diversity and species abundance data --- useful for exploratory analysis of metagenomic taxa abundance data
\begin{itemize}
\item \alert{untb} --- unified neutral theory of biodiversity --- simulation of ecological drift and estimation of biodiversity parameters
\item \alert{vegan} --- large package for community ecology --- fitting species abundance distributions (SADs), estimating number of unobserved species, etc.
\item \alert{sads} --- simulation of and MLE for SADs (including Poisson--log-normal)
\item \alert{BAT} --- biodiversity assessment tools
\item \alert{BiodiversityR} --- mainly a GUI interface for vegan
\end{itemize}
The CRAN Task View for \alert{Environmetrics} describes many more relevant packages
}

\begin{frame}[fragile]
\frametitle{Analysis of species abundance data in R}
{\scriptsize
\begin{lstlisting}
library(vegan)
library(sads)

comm = rsad(S=1000,frac=1,sad="lnorm",meanlog=5,sdlog=2)
barplot(comm,xlab="Species",ylab="Abundance")
comm = comm[order(-comm)]

tad = as.data.frame(table(comm))
names(tad) = c("Abundance","# taxa")
barplot(tad[,2],names.arg=tad[,1],xlab="Abundance",
                                ylab="# species",main="TAD")
tad$Abundance = as.numeric(as.character(tad$Abundance))

oc = octav(comm)
plot(oc,main="Preston plot")
plot(rad(comm),"Rank abundance")
\end{lstlisting}}
\end{frame}

\frame{
\frametitle{Analysis of species abundance data in R}
\centerline{\includegraphics[height=0.8\textheight]{full}}
}

\begin{frame}[fragile]
\frametitle{Analysis of species abundance data in R}
{\small
\begin{lstlisting}
comm=rsad(S=1000,frac=0.0002,sad="lnorm",
                                meanlog=5,sdlog=2)
barplot(comm,xlab="Species",ylab="Abundance")
comm = comm[order(-comm)]

tad = as.data.frame(table(comm))
names(tad) = c("Abundance","# taxa")
barplot(tad[,2],names.arg=tad[,1],xlab="Abundance",
                          ylab="# species",main="TAD")
tad$Abundance = as.numeric(as.character(tad$Abundance))

oc = octav(comm)
plot(oc,main="Preston plot")
plot(rad(comm),"Rank abundance")
\end{lstlisting}}
\end{frame}


\frame{
\frametitle{Analysis of species abundance data in R}
\centerline{\includegraphics[height=0.8\textheight]{partial}}
}

\begin{frame}[fragile]
\frametitle{Analysis of species abundance data in R}
{\scriptsize
\begin{lstlisting}
> print(estimateR(comm))
    S.obs   S.chao1  se.chao1     S.ACE    se.ACE 
114.00000 321.56250  69.70477 356.01381  11.74045 
> mod = fitsad(comm)
> print(mod)
Maximum likelihood estimation
Type: continuous  species abundance distribution
Species: 114 individuals: 196 

Call:
mle2(minuslogl = function (N, S) 
-sum(dbs(x = x, N = N, S = S, log = TRUE)), fixed = list(N = 196L, 
    S = 114L), data = list(x = list(12, 9, 7, 7, 6, "etc")), 
    eval.only = TRUE)

Coefficients:
  N   S 
196 114 

Log-likelihood: -175.77 
> plot(mod)
\end{lstlisting}}
\end{frame}

\frame{
\frametitle{Analysis of species abundance data in R}
\centerline{\includegraphics[height=0.8\textheight]{lnfit}}
}

\begin{frame}[fragile]
\frametitle{Analysis of species abundance data in R}
{\scriptsize
\begin{lstlisting}
> mod=fitsad(comm,"poilog")
> print(mod)
Maximum likelihood estimation
Type: discrete  species abundance distribution
Species: 114 individuals: 196 

Call:
mle2(minuslogl = function (mu, sig) 
-sum(dtrunc("poilog", x = x, coef = list(mu = mu, sig = sig), 
    trunc = trunc, log = TRUE)), start = list(mu = -3.53145726216054, 
    sig = 1.90294684566867), data = list(x = list(12, 9, 7, 7, 
    6, "etc")))

Coefficients:
       mu       sig 
-3.531457  1.902947 

Truncation point: 0 

Log-likelihood: -122.64 
> plot(mod)
\end{lstlisting}}
\end{frame}

\frame{
\frametitle{Analysis of species abundance data in R}
\centerline{\includegraphics[height=0.8\textheight]{plfit}}
R Script: \url{gist.github.com/darrenjw} \hspace{5ex} \texttt{sads-test.R}
}


\frame{
\frametitle{Limitations of (much) available software}
\begin{itemize}
\item Most packages have been designed with more classical population ecology examples in mind, and not all algorithms scale (well) to the very large number of species often observed in metagenomic samples
\item Many algorithms are rather simplistic and produce poor estimates
\item Most SAD fitting algorithms fit directly to the \alert{observed} SAD, rather than the unobserved \alert{population} SAD --- yet it is typically the population SAD that is of scientific interest
\item Despite the large uncertainties present, many algorithms either provide point estimates only, or provide simple interval estimates --- they can't easily \alert{propagate uncertainty} to downstream derived parameters, such as an estimate of required sequencing effort
\end{itemize}
}

\section{Bayesian methods}

\frame{
\frametitle{Bayesian MCMC approaches}
\begin{itemize}
\item Bayesian hierarchical models provide an elegant framework for describing all observed and unobserved quantities in a statistical model, incorporating both \alert{model} and \alert{parameter uncertainty}, including
  \begin{itemize}
  \item uncertainty about the parametric form of the true population SAD
  \item the unobserved population SAD, in addition to the observed (sampled) SAD
  \item the number of (unobserved) species in the population
  \end{itemize}
\item The output from the MCMC algorithm is a (large) sample from the posterior distribution over models and parameters, describing the uncertainty remaining having observed the data
\item The MCMC sample can be used to correctly \alert{propagate uncertainty} to derived parameters, such as an estimate of required sequencing effort
\end{itemize}
}

\frame{
\frametitle{Existing MCMC software}
\alert{BDES} --- Bayesian Diversity Estimation Software (Google search: ``\texttt{Quince BDES}") --- proof-of-concept software associated with: Quince, Curtis, Sloan (2008) The rational exploration of microbial diversity, \emph{ISME}, \textbf{2}, 997--1006.
\begin{itemize}
\item Collection of C programs, each for a particular parametric form of the TAD
\item Build from source code on Linux (library dependence on the GSL)
\item Command-line
\item Not particularly well documented or user-friendly
\item Not very robust, especially for TADs arising from large metagenomic samples
\end{itemize}

}

\frame{
\frametitle{Software under development}
\begin{itemize}
\item Using the same basic ideas and algorithms from BDES, but re-written from scratch in Scala to run on the JVM
\item One algorithm to analyse all models simultaneously
\item Proper model comparison
\item Robust analysis for large samples
\item Well documented
\item User-friendly interface (GUI and/or wrapper R package)
\item Distributed as both easy-to-build source and ready-to-run ``assembly jar"
\end{itemize}
Currently in development --- experimental release early 2016 --- ready for general use around Easter 2016 --- also hope to include in EBI Metagenomics analysis pipeline...
}

\frame{
\frametitle{Summary}
\begin{itemize}
\item Tools from population ecology are useful for understanding the biodiversity represented by metagenomic samples
\item The R statistical language has many packages which make it easy to do a range of exploratory data analysis tasks associated with species abundance data
\item Bayesian hierarchical modelling properly models and propagates the uncertainties inherent in the analysis of sample species abundance data
\item Software for Bayesian modelling of species diversity exists now, but more complete and robust software is under development
\end{itemize}
This is joint work with Tom Curtis and Peter Sutovsky, funded jointly with the EBI by the \alert{BBSRC} BBR grant: ``EBI Metagenomics Portal" led by Rob Finn at the EBI
}



\end{document}

% eof

