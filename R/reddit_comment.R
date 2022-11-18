library(RedditExtractoR)


reddit_comments <- NULL


for (i in 979:nrow(reddit_data)){
  print(i)

  content <- reddit_content(paste(reddit_data$post_url[i]))

  r_comments <- data.frame(comment = content$comment)
  r_commenter <- data.frame(commenter = content$user)

  tmp_df <- data.frame(image = reddit_data$title[i],
                       comment = r_comments$comment,
                       commenter = r_commenter$commenter)

  reddit_comments <- rbind(reddit_comments, tmp_df)
  rm(tmp_df)

}
