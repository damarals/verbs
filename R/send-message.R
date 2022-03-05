# Initialize bot
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
  msg_head <- paste0("_Today Verbs (", format(Sys.time(), '%d/%m/%y'), ")_\n\n")
  msg_body <- purrr::map_chr(1:nrow(daily_verbs), function(rw) {
    paste0("Base form: *", daily_verbs[rw,]$infinitivo, "*\n",
           "Past form: *", daily_verbs[rw,]$passado_simples, "*\n",
           "Past participle: *", daily_verbs[rw,]$participio_passado, "*\n",
           "Portuguese translation: *", daily_verbs[rw,]$significado, "*")
  })
  msg <- paste0(msg_head, paste0(msg_body, collapse = "\n---\n"), collapse = "\n")
  bot$sendMessage(chat_id, text = msg, parse_mode = "Markdown")
})
