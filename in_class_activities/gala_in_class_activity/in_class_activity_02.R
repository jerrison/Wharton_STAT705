gala_data <- read.csv("/Users/jerrison/Wharton_MBA/Wharton_STAT705/data/Gala.csv")

head(gala_data, 2)

list_of_strings <- strsplit(as.character(gala_data$What.did.you.like..span.style..text.decoration..underline...best..span..about.the.Black.Tie.Tailgate....Open.Ended.Response),
         split = " ")

unlisted_strings = toupper(unlist(list_of_strings))

head(sort(x = table(unlisted_strings), decreasing = TRUE), n = 10)


