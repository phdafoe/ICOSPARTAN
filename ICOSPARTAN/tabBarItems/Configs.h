/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
===============================*/



/* GLOBAL DEFINES */
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]

#define  DEFAULT_TAB 0


#define  INVITE_FRIENDS_MESSAGE  @"Echa un vistazo a iCoSpartan y vamos a charlar juntos! Puede descargar aquí: http://www.icospartan.com"

#define  PARSE_APP_ID @"Gh9H3fNVIWh7wTHrornH3W7r8haYqbOF41fMJZpR"
#define  PARSE_CLIENT_KEY @"WkS5tyVGZBXAdMZBnJhyP16HAFJ66GaGMRBZGnM0"
//==================================================================================



/*VARIABLE STRINGS FOR PARSE OBJECTS, USER AND CLASSES ===================*/

#define		PF_INSTALLATION_CLASS_NAME			@"_Installation"		//	Class name
#define		PF_INSTALLATION_OBJECTID			@"objectId"				//	String
#define		PF_INSTALLATION_USER				@"user"					//	Pointer to User Class

#define		PF_USER_CLASS_NAME					@"_User"				//	Class name
#define		PF_USER_OBJECTID					@"objectId"				//	String
#define		PF_USER_USERNAME					@"username"				//	String
#define		PF_USER_PASSWORD					@"password"				//	String
#define		PF_USER_EMAIL						@"email"				//	String
#define		PF_USER_PHONE						@"phone"				//	String
#define		PF_USER_STATUS						@"status"				//	String

#define		PF_USER_EMAILCOPY					@"emailCopy"			//	String
#define		PF_USER_FULLNAME					@"fullname"				//	String
#define		PF_USER_FULLNAME_LOWER				@"fullname_lower"		//	String
#define		PF_USER_FACEBOOKID					@"facebookId"			//	String
#define		PF_USER_PICTURE						@"picture"				//	File
#define		PF_USER_THUMBNAIL					@"thumbnail"			//	File

#define		PF_CHAT_CLASS_NAME					@"Chat"					//	Class name
#define		PF_CHAT_USER						@"user"					//	Pointer to User Class
#define		PF_CHAT_ROOMID						@"roomId"				//	String
#define		PF_CHAT_TEXT						@"text"					//	String
#define		PF_CHAT_PICTURE						@"picture"				//	File
#define		PF_CHAT_VIDEO						@"video"				//	File
#define		PF_CHAT_CREATEDAT					@"createdAt"			//	Date

#define		PF_CHATROOMS_CLASS_NAME				@"ChatRooms"			//	Class name
#define		PF_CHATROOMS_NAME					@"name"					//	String

#define		PF_GROUP_NAME					    @"groupName"			//	String

#define		PF_MESSAGES_CLASS_NAME				@"Messages"				//	Class name
#define		PF_MESSAGES_USER					@"user"					//	Pointer to User Class
#define		PF_MESSAGES_ROOMID					@"roomId"				//	String
#define		PF_MESSAGES_DESCRIPTION				@"description"			//	String
#define		PF_MESSAGES_LASTUSER				@"lastUser"				//	Pointer to User Class
#define		PF_MESSAGES_LASTMESSAGE				@"lastMessage"			//	String
#define		PF_MESSAGES_COUNTER					@"counter"				//	Number
#define		PF_MESSAGES_UPDATEDACTION			@"updatedAction"		//	Date

#define		NOTIFICATION_APP_STARTED			@"NCAppStarted"
#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"


