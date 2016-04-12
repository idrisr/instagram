User searching
- (void) createUser:(NSString *)email 
           password:(NSString *)password 
withCompletionBlock:(void (^)(NSError *error))block;

- (void) createUser:(NSString *)email 
           password:(NSString *)password 
withValueCompletionBlock:(void (^)(NSError *error, NSDictionary *result))block;

- (void) removeUser:(NSString *)email 
           password:(NSString *)password 
withCompletionBlock:(void (^)(NSError *error))block;

- (void) changePasswordForUser:(NSString *)email 
                       fromOld:(NSString *)oldPassword 
                        toNew:(NSString *)newPassword withCompletionBlock:(void (^)(NSError *error))block;

- (void) changeEmailForUser:(NSString *)email 
                   password:(NSString *)password 
                 toNewEmail:(NSString *)newEmail withCompletionBlock:(void (^)(NSError *error))block;

- (void) resetPasswordForUser:(NSString *)email 
          withCompletionBlock:(void (^)(NSError* error))block;

- (void) authUser:(NSString *)email 
         password:(NSString *)password 
withCompletionBlock:(void (^)(NSError *error, FAuthData *authData))block;

authentication
@property (nonatomic, strong, readonly) FAuthData *authData;
- (FirebaseHandle) observeAuthEventWithBlock:(void (^)(FAuthData *authData))block;

- (void) removeAuthEventObserverWithHandle:(FirebaseHandle)handle;

- (void) authAnonymouslyWithCompletionBlock:(void (^)(NSError *error, FAuthData *authData))block;

- (void) authUser:(NSString *)email 
         password:(NSString *)password 
withCompletionBlock:(void (^)(NSError *error, FAuthData *authData))block;

- (void) authWithCustomToken:(NSString *)token 
         withCompletionBlock:(void (^)(NSError *error, FAuthData *authData))block;

- (void) authWithOAuthProvider:(NSString *)provider 
                         token:(NSString *)oauthToken 
           withCompletionBlock:(void (^) (NSError *error, FAuthData *authData))block;

- (void) authWithOAuthProvider:(NSString *)provider 
                    parameters:(NSDictionary *)parameters 
           withCompletionBlock:(void (^) (NSError *error, FAuthData *authData))block;

- (void) makeReverseOAuthRequestTo:(NSString *)provider 
               withCompletionBlock:(void (^)(NSError *error, NSDictionary *json))block;

- (void) unauth;

- (void) authWithCredential:(NSString *)credential 
        withCompletionBlock:(void (^) (NSError* error, id data))block 
            withCancelBlock:(void (^)(NSError* error))cancelBlock __attribute__((deprecated("Use authWithCustomToken:withCompletionblock: instead")));

- (void) unauthWithCompletionBlock:(void (^)(NSError* error))block __attribute__((deprecated("Use unauth: instead")));
