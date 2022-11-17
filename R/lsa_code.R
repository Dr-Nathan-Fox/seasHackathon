library(lsa)
library(tm)
library(LSAfun)
library(gplots)
library(sparcl)
library(NbClust)
library(factoextra)

# 1. Do LSA --------------------------------------------------------------------
flickr_raw$text <- paste2(flickr_raw$title,
                          flickr_raw$description,
                          flickr_raw$tags)

flickr_raw$text <- (gsub(",", " ", flickr_raw$text))

cols.num <- c("text")
flickr_raw[cols.num] <- sapply(flickr_raw[cols.num], as.character)

Encoding(flickr_raw$text) <- "UTF-8"
flickr_raw$text <- iconv(flickr_raw$text, "UTF-8", "UTF-8",sub='')
flickr_raw$text <- iconv(flickr_raw$text, 'utf-8', 'ascii', sub='')

flickr_corpus <- Corpus(VectorSource(flickr_raw$text),
                         readerControl=list(language='en'))

num_keep <- round(length(flickr_corpus)/100 * 5)
stoplist <- c(stopwords("en"))

#create
flickr_TDM <- TermDocumentMatrix(flickr_corpus,
                                  control=list(removePunctuation = FALSE,
                                               removeNumbers = TRUE,
                                               tolower = TRUE,
                                               stopwords = stoplist,
                                               stemming = FALSE, # snowball stemmer
                                               weighting = function(x) weightTfIdf(x, normalize = FALSE), # Weight with tf-idf
                                               bounds=list(global=c(num_keep,Inf)))) # Keep only 5 or more appearances, to accelerate

#carry out the lsa
flickr_LSA <- lsa(flickr_TDM, dims=dimcalc_share())

#creat term matrix from lsa matricies
flickr_tk = t(flickr_LSA$sk * t(flickr_LSA$tk))
flickr_dims <- ncol(flickr_tk)

#extract term names
flickr_terms <- rownames(flickr_tk)

#calculate cosine similarity between terms
flickr_CosineSpace <- multicos(flickr_terms,
                                tvectors = flickr_tk)

# 2. Calculate clusters --------------------------------------------------------
#change similarity to distance
flickr_CosineDist <- as.dist(1 - flickr_CosineSpace)

#dist also as a matrix
flickr_CosineDistMat <- data.matrix(flickr_CosineDist,
                                     rownames.force = NA)


#find the correct number of cluctsers
flickr_fviz <- fviz_nbclust(flickr_CosineDistMat, #needs matrix to work
                             FUN = hcut,
                             hc_method = "ward.D",
                             method = "silhouette",
                             k.max = flickr_dims)

plot(flickr_fviz)
ggplot2::ggsave(filename = "flickr_hiking_Nclusters.png", dpi = 400)

#find number of clusters at highest silhouette value
flickr_fviz <- flickr_fviz$data
flickr_fviz <- flickr_fviz[which.max(flickr_fviz$y),]
numb_clust <- as.numeric(flickr_fviz$clusters)

#hclust
flickr_wardClust <- hclust(flickr_CosineDist, #needs to be dist to work
                            method = "ward.D")

#cut tree at based on silhouette
flickr_topics <- cutree(flickr_wardClust,
                         k = as.numeric(numb_clust))


#save dendogram as .jpeg
ColorDendrogram(flickr_wardClust,
                y = flickr_topics,
                labels = names(flickr_topics),
                xlab = "Tags",
                sub = "",
                branchlength = max(flickr_wardClust$height)/5)

ggplot2::ggsave(filename = "flickr_dendo.png", dpi = 400)

# 3. find the average number of times a label from a cluster appears -----------
#create a dataframe that has each word alongside it cluster group number
flickr_topics <- as.data.frame(flickr_topics)
flickr_topics <- tibble::rownames_to_column(flickr_topics)

#find the frequency of a term in the original TDM
#(i.e. finds frequency of stemmed words as opposed to each individual word)
flickr_freq <- data.frame("tag" = NULL, "freq" = NULL)

flickr_text <- flickr_raw %>%
  unnest_tokens(word, text)

flickr_text <- data.frame(table(unlist(flickr_text$word)))

for (i in 1:nrow(flickr_topics)){

  name <- flickr_topics[i, 1]

  freq <- subset(flickr_text, Var1 == name)
  freq <- as.numeric(freq$Freq[1])

  tmp_df <- data.frame("tag" = name,
                       "freq" = freq,
                       stringsAsFactors = FALSE)

  flickr_freq <- rbind(flickr_freq, tmp_df)

}

#calculate the frequency of each topic
flickr_group_freq <- NULL

for (i in 1:length(unique(flickr_topics$flickr_topics))){

  flickr_group <- flickr_topics[flickr_topics[, 2] == i,]

  freq <- NULL
  total_freq <- 0

  for(j in 1:nrow(flickr_group)){

    tag <- flickr_group$rowname[j]

    freq <- flickr_freq[which(flickr_freq$tag == tag), 2]

    total_freq <- total_freq + freq


  }

  group_total <- data.frame("flickr_topics" = i, "freq" = total_freq)

  flickr_group_freq <- rbind(flickr_group_freq, group_total)

}

#dataframe of words in each topic one cell per topic
flickr_topics <- flickr_topics %>%
  group_by(flickr_topics) %>%
  summarise(rowname = (paste(rowname, collapse = ", ")))

#merge group words with their total frequency
flickr_topics <- merge(flickr_topics,
                        flickr_group_freq,
                        by = "flickr_topics")

#create average freq
flickr_topics$avg <- flickr_topics$freq /
  sapply(strsplit(flickr_topics$rowname, " "), length)

#save the merged dataframe - (grouped words plus their combined freq)
write.csv(flickr_topics,
          paste0("flickr_",search_term,"_topics.csv", sep = ""))
