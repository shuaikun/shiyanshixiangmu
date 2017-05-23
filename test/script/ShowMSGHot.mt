ITTImageView * Tap %thinktime=4000 %timeout=4000
Debug * Print 查看电影详情
Button "home cinema detail big(2)" Tap %thinktime=4000 %timeout=4000
Button 剧照 Verify %thinktime=4000 %timeout=4000
Button "Header back btn" Tap %thinktime=4000 %timeout=4000
Button #mt(2) Tap %thinktime=4000 %timeout=4000
Debug * Print 查看剧照
ITTImageView * Tap %thinktime=4000 %timeout=4000
Button "home cinema detail big(2)" Tap %thinktime=4000 %timeout=4000
Button 剧照 Tap %thinktime=4000 %timeout=4000
ITTImageView /var/mobile/Applications/D93D67C5-C167-4F9A-B7C0-AF6CBF24695E/Library/Caches/images/http%3A%2F%2F120.196.125.11%3A14680%2Fmovieposter%2Fimage%2Fdirenjiezhishendulongwang11.jpg Tap %thinktime=4000 %timeout=4000
Scroller * Scroll 320 0 %thinktime=4000 %timeout=4000
Scroller * Scroll 640 0 %thinktime=4000 %timeout=4000
Scroller * Scroll 960 0 %thinktime=4000 %timeout=4000
Button "Header back btn" Tap %thinktime=4000 %timeout=4000
Button "Header back btn" Tap %thinktime=4000 %timeout=4000
Button #mt(2) Tap %thinktime=4000 %timeout=4000
Debug * Print 分享电影信息
ITTImageView * Tap %thinktime=4000 %timeout=4000
Button "home cinema detail big(2)" Tap %thinktime=4000 %timeout=4000
Button "share btn" Tap %thinktime=4000 %timeout=4000
Button 新浪微博分享 Verify %thinktime=4000 %timeout=4000
Button 新浪微博分享 Tap %thinktime=4000 %timeout=4000
Label 新浪微博分享 VerifyWildcard 新浪* %thinktime=4000 %timeout=4000
Button "sina share btn" Tap %thinktime=4000 %timeout=4000
Button "Header back btn" Tap %thinktime=4000 %timeout=4000
Button #mt(2) Tap %thinktime=4000 %timeout=4000