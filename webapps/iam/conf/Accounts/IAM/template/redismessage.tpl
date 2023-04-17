{
"Clear Tickets":{"handler":"com.zoho.accounts.messaging.RedisMessageHandler","method":"clearTickets"},
"Clear ISC Tickets":{"handler":"com.zoho.accounts.messaging.RedisMessageHandler","method":"clearISCTickets"},
"Clear IAM3 AgentCache":{"handler":"com.zoho.accounts.messaging.RedisMessageHandler","method":"clearIAM3AgentCacheConf"},
"Clear IAM2 Proxy Object":{"handler":"com.zoho.accounts.messaging.RedisMessageHandler","method":"clearCacheConfiguration"},
"Clear Cache":{"handler":"com.zoho.accounts.messaging.RedisMessageHandler","method":"clearCache"},
"Clear User's Ticket":{"handler":"com.zoho.accounts.messaging.RedisMessageHandler","method":"handleClearUserTicket"},
"Toggle Stats Handlers":{"handler":"com.zoho.accounts.messaging.RedisMessageHandler","method":"toggleRedisStats"}
}