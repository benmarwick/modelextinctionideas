# ingest ---------------------------------

# read in the data, TOPIC = "Archaeology", document type = "Article", all years
saa2018_files <- dir("../data/raw_data/wos/",  full.names = TRUE)

text <- map(saa2018_files, ~read_file(.x, locale = locale(encoding = "latin1")))

# split on article delimiter provided by WOS
library(stringr)
items <- unlist(str_split(text, pattern = "\nPT J\n"))
# get rid of the advertising
items <- str_replace_all(items, "FN Clarivate Analytics Web of Science\nVR 1.0", "")
items <- items[items != ""]

length(items) # each item is one article

# function to automate getting the variables out of each item
extractor <- function(i){

  # debug with
  # i <- items[[3]]

  authors =     gsub(".*AU *(.*?) *\nAF .*", "\\1", i)
  authors_n =   str_count(authors, "\n") + 1
  title =       gsub(".*\nTI *(.*?) *\nSO .*", "\\1", i)
  title_n =     str_count(title, " ") - 1
  journal =     gsub(".*\nSO *(.*?) *\nLA .*", "\\1", i)
  abstract =    gsub(".*\nAB *(.*?) *\nC1 .*", "\\1", i)
  refs =        gsub(".*\nCR *(.*?) *\nNR .*", "\\1", i)
  refs_n =      as.numeric(gsub(".*\nNR *(.*?) *\nTC .*", "\\1", i))
  pages_n =     as.numeric(gsub(".*\nPG *(.*?) *\nWC .*", "\\1", i))
  year =        as.numeric(gsub(".*\nPY *(.*?) *\nVL .*", "\\1", i))

  dplyr::data_frame(
    authors =         authors,
    authors_n =       authors_n,
    title =           title ,
    title_n =         title_n,
    journal =         journal,
    abstract  =       abstract,
    refs =            refs    ,
    refs_n =          refs_n ,
    pages_n =         pages_n,
    year =            year
  )
}


# # for debugging, to find the items that break the fn
# for(i in seq_len(length(items))){
#   extractor(items[i])
#   print(i)
# }


# this will take a few mins
# items_df <- map_df(items, ~extractor(.x))

# saveRDS(items_df, "data/SAA2018/saa2018-data-df.rds")
