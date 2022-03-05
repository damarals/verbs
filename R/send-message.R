# Initialize bot
print(telegram.bot::bot_token("verbs"))
bot <- telegram.bot::Bot(token = telegram.bot::bot_token("verbs"))

# Get updates
updates <- bot$getUpdates()

# Retrieve chat ids
chat_ids <- sapply(updates, function(msg) msg$from_chat_id())

# Create daily verbs message
seed <- as.numeric(Sys.time())
set.seed(seed)

verbs <- read.csv("data/verbs.csv", fileEncoding = "utf-8")
daily_verbs <- verbs[sample(x = 1:nrow(verbs), size = 2),]

# Send message
purrr::walk(unique(chat_ids), function(chat_id) {
  msg_head <- paste0("_Today Verbs_ (", format(Sys.time(), '%d/%m/%y'), ")")
  msg_body <- purrr::map_chr(1:nrow(daily_verbs), function(rw) {
    paste0("Base form: *", daily_verbs[rw,]$infinitivo, "*<br>",
           "Past form: *", daily_verbs[rw,]$passado_simples, "*<br>",
           "Past participle: *", daily_verbs[rw,]$participio_passado, "*<br>",
           "Portuguese translation: *", daily_verbs[rw,]$significado, "*")
  })
  msg <- paste0(msg_head, paste0(msg_body, collapse = "<br>---<br>"), collapse = "<br>")
  bot$sendMessage(chat_id, text = msg, parse_mode = "Markdown")
})
