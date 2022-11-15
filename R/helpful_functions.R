#' paste2
#' function to paste without copying NAs
#' @param ...
#' @param sep
#'
#' @return
#' @export
#'
#' @examples
paste2 <- function(...,sep=", ") {
  L <- list(...)
  L <- lapply(L,function(x) {x[is.na(x)] <- ""; x})
  gsub(paste0("(^",sep,"|",sep,"$)"),"",
       gsub(paste0(sep,sep),sep,
            do.call(paste,c(L,list(sep=sep)))))
}

#' flickr_afinn
#' Added a column for the afinn sentiment for each photo
#'
#' @param flickr_data
#'
#' @return
#' @export
#'
#' @examples
flickr_afinn <- function(flickr_data = NULL){ #data will = your search

  afinn <- flickr_data %>%
    unnest_tokens(word, text) %>%
    inner_join(get_sentiments("afinn")) %>% # afinn values as a new column
    group_by(id) %>% #tell R to treat each unique url as a group
    summarise(afinn_sentiment = sum(value)) #sum the sentiment value of that group

  out <- merge(flickr_data, afinn, by = "id", all = T)

  out$afinn_sentiment[is.na(out$afinn_sentiment)] <- 0

  return(out)

}

#' flikckr_nrc
#' Added a column for the count each of nrc sentiments for each photo
#'
#' @param flickr_data
#'
#' @return
#' @export
#'
#' @examples
flickr_nrc <- function(flickr_data = NULL){ #data will = your search

  nrc <- flickr_data %>%
    unnest_tokens(word, text) %>%
    inner_join(get_sentiments("nrc")) %>%
    count(id, sentiment)

  nrc <- pivot_wider(nrc,
                     names_from = sentiment,
                     values_from = n)

  out <- merge(flickr_data, nrc, by = "id", all = T)

  out$anger[is.na(out$anger)] <- 0
  out$anticipation[is.na(out$anticipation)] <- 0
  out$disgust[is.na(out$disgust)] <- 0
  out$fear[is.na(out$fear)] <- 0
  out$joy[is.na(out$joy)] <- 0
  out$negative[is.na(out$negative)] <- 0
  out$positive[is.na(out$positive)] <- 0
  out$sadness[is.na(out$sadness)] <- 0
  out$trust[is.na(out$trust)] <- 0
  out$surprise[is.na(out$surprise)] <- 0

  return(out)

}
