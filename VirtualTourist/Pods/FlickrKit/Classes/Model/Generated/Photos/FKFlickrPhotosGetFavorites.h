//
//  FKFlickrPhotosGetFavorites.h
//  FlickrKit
//
//  Generated by FKAPIBuilder.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrAPIMethod.h"

typedef NS_ENUM(NSInteger, FKFlickrPhotosGetFavoritesError) {
	FKFlickrPhotosGetFavoritesError_PhotoNotFound = 1,		 /* The specified photo does not exist, or the calling user does not have permission to view it. */
	FKFlickrPhotosGetFavoritesError_InvalidAPIKey = 100,		 /* The API key passed was not valid or has expired. */
	FKFlickrPhotosGetFavoritesError_ServiceCurrentlyUnavailable = 105,		 /* The requested service is temporarily unavailable. */
	FKFlickrPhotosGetFavoritesError_WriteOperationFailed = 106,		 /* The requested operation failed due to a temporary issue. */
	FKFlickrPhotosGetFavoritesError_FormatXXXNotFound = 111,		 /* The requested response format was not found. */
	FKFlickrPhotosGetFavoritesError_MethodXXXNotFound = 112,		 /* The requested method was not found. */
	FKFlickrPhotosGetFavoritesError_InvalidSOAPEnvelope = 114,		 /* The SOAP envelope send in the request could not be parsed. */
	FKFlickrPhotosGetFavoritesError_InvalidXMLRPCMethodCall = 115,		 /* The XML-RPC request document could not be parsed. */
	FKFlickrPhotosGetFavoritesError_BadURLFound = 116,		 /* One or more arguments contained a URL that has been used for abuse on Flickr. */

};

/*

Returns the list of people who have favorited a given photo.


Response:

<photo id="1253576" secret="81b96be690" server="1" farm="1"
	page="1" pages="3" perpage="10" total="27">
	<person nsid="33939862@N00" username="Dementation" favedate="1166689690"/>
	<person nsid="49485425@N00" username="indigenous_prodigy" favedate="1166573724"/>
	<person nsid="46834205@N00" username="smaaz" favedate="1161874052"/>
	<person nsid="95626108@N00" username="chrome Foxpuppy" favedate="1160528154"/>
	<person nsid="44991966@N00" username="getnoid" favedate="1159828789"/>
	<person nsid="92544710@N00" username="miss_rogue" favedate="1158034266"/>
	<person nsid="50944224@N00" username="Infollatus" favedate="1155317436"/>
	<person nsid="80544408@N00" username="DafyddLlyr" favedate="1148511763"/>
	<person nsid="31154299@N00" username="c r i s" favedate="1143085224"/>
	<person nsid="54309070@N00" username="Shinayaker" favedate="1142584219"/>
</photo>

*/
@interface FKFlickrPhotosGetFavorites : NSObject <FKFlickrAPIMethod>

/* The ID of the photo to fetch the favoriters list for. */
@property (nonatomic, copy) NSString *photo_id; /* (Required) */

/* The page of results to return. If this argument is omitted, it defaults to 1. */
@property (nonatomic, copy) NSString *page;

/* Number of usres to return per page. If this argument is omitted, it defaults to 10. The maximum allowed value is 50. */
@property (nonatomic, copy) NSString *per_page;


@end
