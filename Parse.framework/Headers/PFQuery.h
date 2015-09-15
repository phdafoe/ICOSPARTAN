//
//  PFQuery.h
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <Parse/PFConstants.h>
#import <Parse/PFGeoPoint.h>
#import <Parse/PFObject.h>
#import <Parse/PFUser.h>
#else
#import <ParseOSX/PFConstants.h>
#import <ParseOSX/PFGeoPoint.h>
#import <ParseOSX/PFObject.h>
#import <ParseOSX/PFUser.h>
#endif

@class BFTask;

/*!
 The `PFQuery` class defines a query that is used to query for <PFObject>s.
 */
@interface PFQuery : NSObject <NSCopying>

///--------------------------------------
/// @name Creating a Query for a Class
///--------------------------------------

/*!
 @abstract Returns a `PFQuery` for a given class.

 @param className The class to query on.

 @returns A `PFQuery` object.
 */
+ (PFQuery *)queryWithClassName:(NSString *)className;

/*!
 @abstract Creates a PFQuery with the constraints given by predicate.

 @discussion The following types of predicates are supported:

 - Simple comparisons such as `=`, `!=`, `<`, `>`, `<=`, `>=`, and `BETWEEN` with a key and a constant.
 - Containment predicates, such as `x IN {1, 2, 3}`.
 - Key-existence predicates, such as `x IN SELF`.
 - BEGINSWITH expressions.
 - Compound predicates with `AND`, `OR`, and `NOT`.
 - SubQueries with `key IN %@`, subquery.

 The following types of predicates are NOT supported:

 - Aggregate operations, such as `ANY`, `SOME`, `ALL`, or `NONE`.
 - Regular expressions, such as `LIKE`, `MATCHES`, `CONTAINS`, or `ENDSWITH`.
 - Predicates comparing one key to another.
 - Complex predicates with many ORed clauses.

 @param className The class to query on.
 @param predicate The predicate to create conditions from.
 */
+ (PFQuery *)queryWithClassName:(NSString *)className predicate:(NSPredicate *)predicate;

/*!
 Initializes the query with a class name.
 @param newClassName The class name.
 */
- (instancetype)initWithClassName:(NSString *)newClassName;

/*!
 The class name to query for
 */
@property (nonatomic, strong) NSString *parseClassName;

///--------------------------------------
/// @name Adding Basic Constraints
///--------------------------------------

/*!
 @abstract Make the query include PFObjects that have a reference stored at the provided key.

 @discussion This has an effect similar to a join.  You can use dot notation to specify which fields in
 the included object are also fetch.

 @param key The key to load child <PFObject>s for.
 */
- (void)includeKey:(NSString *)key;

/*!
 @abstract Make the query restrict the fields of the returned <PFObject>s to include only the provided keys.

 @discussion If this is called multiple times, then all of the keys specified in each of the calls will be included.

 @param keys The keys to include in the result.
 */
- (void)selectKeys:(NSArray *)keys;

/*!
 @abstract Add a constraint that requires a particular key exists.

 @param key The key that should exist.
 */
- (void)whereKeyExists:(NSString *)key;

/*!
 @abstract Add a constraint that requires a key not exist.

 @param key The key that should not exist.
 */
- (void)whereKeyDoesNotExist:(NSString *)key;

/*!
 @abstract Add a constraint to the query that requires a particular key's object to be equal to the provided object.

 @param key The key to be constrained.
 @param object The object that must be equalled.
 */
- (void)whereKey:(NSString *)key equalTo:(id)object;

/*!
 @abstract Add a constraint to the query that requires a particular key's object to be less than the provided object.

 @param key The key to be constrained.
 @param object The object that provides an upper bound.
 */
- (void)whereKey:(NSString *)key lessThan:(id)object;

/*!
 @abstractAdd a constraint to the query that requires a particular key's object
 to be less than or equal to the provided object.

 @param key The key to be constrained.
 @param object The object that must be equalled.
 */
- (void)whereKey:(NSString *)key lessThanOrEqualTo:(id)object;

/*!
 @abstract Add a constraint to the query that requires a particular key's object
 to be greater than the provided object.

 @param key The key to be constrained.
 @param object The object that must be equalled.
 */
- (void)whereKey:(NSString *)key greaterThan:(id)object;

/*!
 @abstract Add a constraint to the query that requires a particular key's
 object to be greater than or equal to the provided object.

 @param key The key to be constrained.
 @param object The object that must be equalled.
 */
- (void)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object;

/*!
 @abstract Add a constraint to the query that requires a particular key's object
 to be not equal to the provided object.

 @param key The key to be constrained.
 @param object The object that must not be equalled.
 */
- (void)whereKey:(NSString *)key notEqualTo:(id)object;

/*!
 @abstract Add a constraint to the query that requires a particular key's object
 to be contained in the provided array.

 @param key The key to be constrained.
 @param array The possible values for the key's object.
 */
- (void)whereKey:(NSString *)key containedIn:(NSArray *)array;

/*!
 @abstract Add a constraint to the query that requires a particular key's object
 not be contained in the provided array.

 @param key The key to be constrained.
 @param array The list of values the key's object should not be.
 */
- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array;

/*!
 @abstract Add a constraint to the query that requires a particular key's array
 contains every element of the provided array.

 @param key The key to be constrained.
 @param array The array of values to search for.
 */
- (void)whereKey:(NSString *)key containsAllObjectsInArray:(NSArray *)array;

///--------------------------------------
/// @name Adding Location Constraints
///--------------------------------------

/*!
 @abstract Add a constraint to the query that requires a particular key's coordinates (specified via <PFGeoPoint>)
 be near a reference point.

 @discussion Distance is calculated based on angular distance on a sphere. Results will be sorted by distance
 from reference point.

 @param key The key to be constrained.
 @param geopoint The reference point represented as a <PFGeoPoint>.
 */
- (void)whereKey:(NSString *)key nearGeoPoint:(PFGeoPoint *)geopoint;

/*!
 @abstract Add a constraint to the query that requires a particular key's coordinates (specified via <PFGeoPoint>)
 be near a reference point and within the maximum distance specified (in miles).

 @discussion Distance is calculated based on a spherical coordinate system.
 Results will be sorted by distance (nearest to farthest) from the reference point.

 @param key The key to be constrained.
 @param geopoint The reference point represented as a <PFGeoPoint>.
 @param maxDistance Maximum distance in miles.
 */
- (void)whereKey:(NSString *)key nearGeoPoint:(PFGeoPoint *)geopoint withinMiles:(double)maxDistance;

/*!
 @abstract Add a constraint to the query that requires a particular key's coordinates (specified via <PFGeoPoint>)
 be near a reference point and within the maximum distance specified (in kilometers).

 @discussion Distance is calculated based on a spherical coordinate system.
 Results will be sorted by distance (nearest to farthest) from the reference point.

 @param key The key to be constrained.
 @param geopoint The reference point represented as a <PFGeoPoint>.
 @param maxDistance Maximum distance in kilometers.
 */
- (void)whereKey:(NSString *)key nearGeoPoint:(PFGeoPoint *)geopoint withinKilometers:(double)maxDistance;

/*!
 Add a constraint to the query that requires a particular key's coordinates (specified via <PFGeoPoint>) be near
 a reference point and within the maximum distance specified (in radians).  Distance is calculated based on
 angular distance on a sphere.  Results will be sorted by distance (nearest to farthest) from the reference point.

 @param key The key to be constrained.
 @param geopoint The reference point as a <PFGeoPoint>.
 @param maxDistance Maximum distance in radians.
 */
- (void)whereKey:(NSString *)key nearGeoPoint:(PFGeoPoint *)geopoint withinRadians:(double)maxDistance;

/*!
 @abstract Add a constraint to the query that requires a particular key's coordinates (specified via <PFGeoPoint>) be
 contained within a given rectangular geographic bounding box.

 @param key The key to be constrained.
 @param southwest The lower-left inclusive corner of the box.
 @param northeast The upper-right inclusive corner of the box.
 */
- (void)whereKey:(NSString *)key withinGeoBoxFromSouthwest:(PFGeoPoint *)southwest toNortheast:(PFGeoPoint *)northeast;

///--------------------------------------
/// @name Adding String Constraints
///--------------------------------------

/*!
 @abstract Add a regular expression constraint for finding string values that match the provided regular expression.

 @warning This may be slow for large datasets.

 @param key The key that the string to match is stored in.
 @param regex The regular expression pattern to match.
 */
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex;

/*!
 @abstract Add a regular expression constraint for finding string values that match the provided regular expression.

 @warning This may be slow for large datasets.

 @param key The key that the string to match is stored in.
 @param regex The regular expression pattern to match.
 @param modifiers Any of the following supported PCRE modifiers:
 - `i` - Case insensitive search
 - `m` - Search across multiple lines of input
 */
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex modifiers:(NSString *)modifiers;

/*!
 @abstract Add a constraint for finding string values that contain a provided substring.

 @warning This will be slow for large datasets.

 @param key The key that the string to match is stored in.
 @param substring The substring that the value must contain.
 */
- (void)whereKey:(NSString *)key containsString:(NSString *)substring;

/*!
 @abstract Add a constraint for finding string values that start with a provided prefix.

 @discussion This will use smart indexing, so it will be fast for large datasets.

 @param key The key that the string to match is stored in.
 @param prefix The substring that the value must start with.
 */
- (void)whereKey:(NSString *)key hasPrefix:(NSString *)prefix;

/*!
 @abstract Add a constraint for finding string values that end with a provided suffix.

 @warning This will be slow for large datasets.

 @param key The key that the string to match is stored in.
 @param suffix The substring that the value must end with.
 */
- (void)whereKey:(NSString *)key hasSuffix:(NSString *)suffix;

///--------------------------------------
/// @name Adding Subqueries
///--------------------------------------

/*!
 Returns a `PFQuery` that is the `or` of the passed in queries.

 @param queries The list of queries to or together.

 @returns An instance of `PFQuery` that is the `or` of the passed in queries.
 */
+ (PFQuery *)orQueryWithSubqueries:(NSArray *)queries;

/*!
 @abstract Adds a constraint that requires that a key's value matches a value in another key
 in objects returned by a sub query.

 @param key The key that the value is stored.
 @param otherKey The key in objects in the returned by the sub query whose value should match.
 @param query The query to run.
 */
- (void)whereKey:(NSString *)key matchesKey:(NSString *)otherKey inQuery:(PFQuery *)query;

/*!
 @abstract Adds a constraint that requires that a key's value `NOT` match a value in another key
 in objects returned by a sub query.

 @param key The key that the value is stored.
 @param otherKey The key in objects in the returned by the sub query whose value should match.
 @param query The query to run.
 */
- (void)whereKey:(NSString *)key doesNotMatchKey:(NSString *)otherKey inQuery:(PFQuery *)query;

/*!
 @abstract Add a constraint that requires that a key's value matches a `PFQuery` constraint.

 @warning This only works where the key's values are <PFObject>s or arrays of <PFObject>s.

 @param key The key that the value is stored in
 @param query The query the value should match
 */
- (void)whereKey:(NSString *)key matchesQuery:(PFQuery *)query;

/*!
 @abstract Add a constraint that requires that a key's value to not match a `PFQuery` constraint.

 @warning This only works where the key's values are <PFObject>s or arrays of <PFObject>s.

 @param key The key that the value is stored in
 @param query The query the value should not match
 */
- (void)whereKey:(NSString *)key doesNotMatchQuery:(PFQuery *)query;

///--------------------------------------
/// @name Sorting
///--------------------------------------

/*!
 @abstract Sort the results in *ascending* order with the given key.

 @param key The key to order by.
 */
- (void)orderByAscending:(NSString *)key;

/*!
 @abstract Additionally sort in *ascending* order by the given key.

 @discussion The previous keys provided will precedence over this key.

 @param key The key to order bye
 */
- (void)addAscendingOrder:(NSString *)key;

/*!
 @abstract Sort the results in *descending* order with the given key.

 @param key The key to order by.
 */
- (void)orderByDescending:(NSString *)key;

/*!
 @abstract Additionally sort in *descending* order by the given key.

 @discussion The previous keys provided will precedence over this key.

 @param key The key to order bye
 */
- (void)addDescendingOrder:(NSString *)key;

/*!
 @abstract Sort the results using a given sort descriptor.

 @param sortDescriptor The `NSSortDescriptor` to use to sort the results of the query.
 */
- (void)orderBySortDescriptor:(NSSortDescriptor *)sortDescriptor;

/*!
 @abstract Sort the results using a given array of sort descriptors.

 @param sortDescriptors An array of `NSSortDescriptor` objects to use to sort the results of the query.
 */
- (void)orderBySortDescriptors:(NSArray *)sortDescriptors;

///--------------------------------------
/// @name Getting Objects by ID
///--------------------------------------

/*!
 @abstract Returns a <PFObject> with a given class and id.

 @param objectClass The class name for the object that is being requested.
 @param objectId The id of the object that is being requested.

 @returns The <PFObject> if found. Returns `nil` if the object isn't found, or if there was an error.
 */
+ (PFObject *)getObjectOfClass:(NSString *)objectClass
                      objectId:(NSString *)objectId;

/*!
 @abstract Returns a <PFObject> with a given class and id and sets an error if necessary.

 @param objectClass The class name for the object that is being requested.
 @param objectId The id of the object that is being requested.
 @param error Pointer to an `NSError` that will be set if necessary.

 @returns The <PFObject> if found. Returns `nil` if the object isn't found, or if there was an `error`.
 */
+ (PFObject *)getObjectOfClass:(NSString *)objectClass
                      objectId:(NSString *)objectId
                         error:(NSError **)error;

/*!
 @abstract Returns a <PFObject> with the given id.

 @warning This method mutates the query.
 It will reset limit to `1`, skip to `0` and remove all conditions, leaving only `objectId`.

 @param objectId The id of the object that is being requested.

 @returns The <PFObject> if found. Returns nil if the object isn't found, or if there was an error.
 */
- (PFObject *)getObjectWithId:(NSString *)objectId;

/*!
 @abstract Returns a <PFObject> with the given id and sets an error if necessary.

 @warning This method mutates the query.
 It will reset limit to `1`, skip to `0` and remove all conditions, leaving only `objectId`.

 @param objectId The id of the object that is being requested.
 @param error Pointer to an `NSError` that will be set if necessary.

 @returns The <PFObject> if found. Returns nil if the object isn't found, or if there was an error.
 */
- (PFObject *)getObjectWithId:(NSString *)objectId error:(NSError **)error;

/*!
 @abstract Gets a <PFObject> asynchronously and calls the given block with the result.

 @warning This method mutates the query.
 It will reset limit to `1`, skip to `0` and remove all conditions, leaving only `objectId`.

 @param objectId The id of the object that is being requested.

 @returns The task, that encapsulates the work being done.
 */
- (BFTask *)getObjectInBackgroundWithId:(NSString *)objectId;

/*!
 @asbtract Gets a <PFObject> asynchronously and calls the given block with the result.

 @warning This method mutates the query.
 It will reset limit to `1`, skip to `0` and remove all conditions, leaving only `objectId`.

 @param objectId The id of the object that is being requested.
 @param block The block to execute.
 The block should have the following argument signature: `^(NSArray *object, NSError *error)`
 */
- (void)getObjectInBackgroundWithId:(NSString *)objectId
                              block:(PFObjectResultBlock)block;

/*!
 @abstract Gets a <PFObject> asynchronously.

 This mutates the PFQuery. It will reset limit to `1`, skip to `0` and remove all conditions, leaving only `objectId`.

 @param objectId The id of the object being requested.
 @param target The target for the callback selector.
 @param selector The selector for the callback.
 It should have the following signature: `(void)callbackWithResult:(id)result error:(NSError *)error`.
 Result will be `nil` if error is set and vice versa.
 */
- (void)getObjectInBackgroundWithId:(NSString *)objectId
                             target:(id)target
                           selector:(SEL)selector;

///--------------------------------------
/// @name Getting User Objects
///--------------------------------------

/*!
 @asbtract Returns a <PFUser> with a given id.

 @param objectId The id of the object that is being requested.

 @returns The PFUser if found. Returns nil if the object isn't found, or if there was an error.
 */
+ (PFUser *)getUserObjectWithId:(NSString *)objectId;

/*!
 Returns a PFUser with a given class and id and sets an error if necessary.
 @param objectId The id of the object that is being requested.
 @param error Pointer to an NSError that will be set if necessary.
 @result The PFUser if found. Returns nil if the object isn't found, or if there was an error.
 */
+ (PFUser *)getUserObjectWithId:(NSString *)objectId
                          error:(NSError **)error;

/*!
 @deprecated Please use [PFUser query] instead.
 */
+ (PFQuery *)queryForUser PARSE_DEPRECATED("Use [PFUser query] instead.");

///--------------------------------------
/// @name Getting all Matches for a Query
///--------------------------------------

/*!
 @asbtract Finds objects *synchronously* based on the constructed query.

 @returns Returns an array of <PFObject> objects that were found.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *findObjects;

/*!
 @abstract Finds objects *synchronously* based on the constructed query and sets an error if there was one.

 @param error Pointer to an `NSError` that will be set if necessary.

 @returns Returns an array of <PFObject> objects that were found.
 */
- (NSArray *)findObjects:(NSError **)error;

/*!
 @asbtract Finds objects *asynchronously* and sets the `NSArray` of <PFObject> objects as a result of the task.

 @returns The task, that encapsulates the work being done.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) BFTask *findObjectsInBackground;

/*!
 @abstract Finds objects *asynchronously* and calls the given block with the results.

 @param block The block to execute.
 It should have the following argument signature: `^(NSArray *objects, NSError *error)`
 */
- (void)findObjectsInBackgroundWithBlock:(PFArrayResultBlock)block;

/*!
 @abstract Finds objects *asynchronously* and calls the given callback with the results.

 @param target The object to call the selector on.
 @param selector The selector to call.
 It should have the following signature: `(void)callbackWithResult:(id)result error:(NSError *)error`.
 Result will be `nil` if error is set and vice versa.
 */
- (void)findObjectsInBackgroundWithTarget:(id)target selector:(SEL)selector;

///--------------------------------------
/// @name Getting the First Match in a Query
///--------------------------------------

/*!
 @abstract Gets an object *synchronously* based on the constructed query.

 @warning This method mutates the query. It will reset the limit to `1`.

 @returns Returns a <PFObject>, or `nil` if none was found.
 */
@property (NS_NONATOMIC_IOSONLY, getter=getFirstObject, readonly, strong) PFObject *firstObject;

/*!
 @abstract Gets an object *synchronously* based on the constructed query and sets an error if any occurred.

 @warning This method mutates the query. It will reset the limit to `1`.

 @param error Pointer to an `NSError` that will be set if necessary.

 @returns Returns a <PFObject>, or `nil` if none was found.
 */
- (PFObject *)getFirstObject:(NSError **)error;

/*!
 @abstract Gets an object *asynchronously* and sets it as a result of the task.

 @warning This method mutates the query. It will reset the limit to `1`.

 @returns The task, that encapsulates the work being done.
 */
@property (NS_NONATOMIC_IOSONLY, getter=getFirstObjectInBackground, readonly, strong) BFTask *firstObjectInBackground;

/*!
 @abstract Gets an object *asynchronously* and calls the given block with the result.

 @warning This method mutates the query. It will reset the limit to `1`.

 @param block The block to execute.
 It should have the following argument signature: `^(PFObject *object, NSError *error)`.
 `result` will be `nil` if `error` is set OR no object was found matching the query.
 `error` will be `nil` if `result` is set OR if the query succeeded, but found no results.
 */
- (void)getFirstObjectInBackgroundWithBlock:(PFObjectResultBlock)block;

/*!
 @abstract Gets an object *asynchronously* and calls the given callback with the results.

 @warning This method mutates the query. It will reset the limit to `1`.

 @param target The object to call the selector on.
 @param selector The selector to call.
 It should have the following signature: `(void)callbackWithResult:(PFObject *)result error:(NSError *)error`.
 `result` will be `nil` if `error` is set OR no object was found matching the query.
 `error` will be `nil` if `result` is set OR if the query succeeded, but found no results.
 */
- (void)getFirstObjectInBackgroundWithTarget:(id)target selector:(SEL)selector;

///--------------------------------------
/// @name Counting the Matches in a Query
///--------------------------------------

/*!
 @abstract Counts objects *synchronously* based on the constructed query.

 @returns Returns the number of <PFObject> objects that match the query, or `-1` if there is an error.
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger countObjects;

/*!
 @abstract Counts objects *synchronously* based on the constructed query and sets an error if there was one.

 @param error Pointer to an `NSError` that will be set if necessary.

 @returns Returns the number of <PFObject> objects that match the query, or `-1` if there is an error.
 */
- (NSInteger)countObjects:(NSError **)error;

/*!
 @abstract Counts objects *asynchronously* and sets `NSNumber` with count as a result of the task.

 @returns The task, that encapsulates the work being done.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) BFTask *countObjectsInBackground;

/*!
 @abstract Counts objects *asynchronously* and calls the given block with the counts.

 @param block The block to execute.
 It should have the following argument signature: `^(int count, NSError *error)`
 */
- (void)countObjectsInBackgroundWithBlock:(PFIntegerResultBlock)block;

/*!
 @abstract Counts objects *asynchronously* and calls the given callback with the count.

 @param target The object to call the selector on.
 @param selector The selector to call.
 It should have the following signature: `(void)callbackWithResult:(NSNumber *)result error:(NSError *)error`.
 */
- (void)countObjectsInBackgroundWithTarget:(id)target selector:(SEL)selector;

///--------------------------------------
/// @name Cancelling a Query
///--------------------------------------

/*!
 @asbtract Cancels the current network request (if any). Ensures that callbacks won't be called.
 */
- (void)cancel;

///--------------------------------------
/// @name Paginating Results
///--------------------------------------

/*!
 @abstract A limit on the number of objects to return. The default limit is `100`, with a
 maximum of 1000 results being returned at a time.

 @warning If you are calling `findObjects` with `limit = 1`, you may find it easier to use `getFirst` instead.
 */
@property (nonatomic, assign) NSInteger limit;

/*!
 @abstract The number of objects to skip before returning any.
 */
@property (nonatomic, assign) NSInteger skip;

///--------------------------------------
/// @name Controlling Caching Behavior
///--------------------------------------

/*!
 @abstract The cache policy to use for requests.

 Not allowed when Pinning is enabled.

 @see fromLocalDatastore:
 @see fromPin:
 @see fromPinWithName:
 */
@property (assign, readwrite) PFCachePolicy cachePolicy;

/* !
 @asbtract The age after which a cached value will be ignored
 */
@property (assign, readwrite) NSTimeInterval maxCacheAge;

/*!
 @abstract Returns whether there is a cached result for this query.

 @result `YES` if there is a cached result for this query, otherwise `NO`.
 */
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL hasCachedResult;

/*!
 @abstract Clears the cached result for this query. If there is no cached result, this is a noop.
 */
- (void)clearCachedResult;

/*!
 @abstract Clears the cached results for all queries.
 */
+ (void)clearAllCachedResults;

///--------------------------------------
/// @name Query Source
///--------------------------------------

/*!
 @abstract Change the source of this query to all pinned objects.

 Requires Pinning to be enabled.

 @see cachePolicy
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) PFQuery *fromLocalDatastore;

/*!
 @abstract Change the source of this query to the default group of pinned objects.

 Requires Pinning to be enabled.

 @see PFObjectDefaultPin
 @see cachePolicy
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) PFQuery *fromPin;

/*!
 @abstract Change the source of this query to a specific group of pinned objects.

 Requires Pinning to be enabled.

 @param name The pinned group.

 @see PFObjectDefaultPin
 @see cachePolicy
 */
- (PFQuery *)fromPinWithName:(NSString *)name;

///--------------------------------------
/// @name Advanced Settings
///--------------------------------------

/*!
 @abstract Whether or not performance tracing should be done on the query.

 @warning This should not be set to `YES` in most cases.
 */
@property (nonatomic, assign) BOOL trace;

@end
