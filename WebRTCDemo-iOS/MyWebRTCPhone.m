#import "MyWebRTCPhone.h"

@implementation MyWebRTCPhone

- (MyWebRTCPhone *)init{
	self.moduleString = @"<!doctype html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta content=\"width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no\" name=\"viewport\"><meta content=\"yes\" name=\"apple-mobile-web-app-capable\"><title></title><style>html,body{margin:0;padding:0}body{background:#3780cd;font-family:sans-serif;font-size:18px;color:#fff;font-weight:700}div{text-align:center;padding:10px}p{margin:0;padding:0;width:50%;display:inline-block;text-align:left}p.right{text-align:right}#video-out{position:relative}#remote_view{width:100%;background:#000}#self_view{width:25%;position:absolute;bottom:30px;left:30px;background:#62bb46}button{border:0;padding:10px;border-radius:3px;background:#fff;color:#62bb46;font-size:18px;font-weight:700}</style></head><body><div id=\"video-out\"><img id=\"remote_view\"><video id=\"self_view\" autoplay muted></video></div><div><p class=\"right\">My Number:&nbsp;</p><p><input type=\"text\" id=\"my_number\" placeholder=\"e.g. 1234\"></p></div><div><p class=\"right\">Friend's Number:&nbsp;</p><p><input type=\"text\" id=\"friend_number\" placeholder=\"e.g. 2345\"></p></div><div id=\"buttons\"><button onclick=\"start_phone()\">Initialize Phone</button></div><div id=\"log_div\"></div><script>var video = document.getElementById('remote_view');\n var logDiv = document.getElementById('log_div');\n function log(str){\n logDiv.innerHTML = str;\n }\n function vid(base64){\n video.src = 'data:image/bmp;base64,' + base64;\n }</script></body></html>";
	
	return self;
}

@end