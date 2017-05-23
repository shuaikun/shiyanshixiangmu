Button "zsq blue will a" Tap %thinktime=4000 %timeout=4000
Debug * Print 查看即将上映影片
MainHeaderView * Tap left %thinktime=4000 %timeout=4000
ITTImageView /var/mobile/Applications/D93D67C5-C167-4F9A-B7C0-AF6CBF24695E/Library/Caches/images/http%3A%2F%2F120.196.125.11%3A14680%2Fmovieposter%2Fimage%2Faipingbeijing9.jpg Tap left %thinktime=4000 %timeout=4000
Debug * Print 查看影片详情
Button "home cinema detail big(2)" Tap left %thinktime=4000 %timeout=4000
Button 剧照 Verify %thinktime=4000 %timeout=4000
Button "Header back btn" Tap left %thinktime=4000 %timeout=4000
Button #mt Tap left %thinktime=4000 %timeout=4000
Debug * Print 遍历剧照
ITTImageView /var/mobile/Applications/D93D67C5-C167-4F9A-B7C0-AF6CBF24695E/Library/Caches/images/http%3A%2F%2F120.196.125.11%3A14680%2Fmovieposter%2Fimage%2Faipingbeijing9.jpg Tap left %thinktime=4000 %timeout=4000
Button "home cinema detail big(2)" Tap left %thinktime=4000 %timeout=4000
Button 剧照 Tap left %thinktime=4000 %timeout=4000
Button 剧情介绍 VerifyWildcard 剧情*
ITTImageView #2 Tap left %thinktime=4000 %timeout=4000
Scroller * Scroll 320 0 %thinktime=4000 %timeout=4000
Scroller * Scroll 640 0 %thinktime=4000 %timeout=4000
Scroller * Scroll 960 0 %thinktime=4000 %timeout=4000
Button "Header back btn" Tap left %thinktime=4000 %timeout=4000
Button "Header back btn" Tap left %thinktime=4000 %timeout=4000
Button #mt Tap left %thinktime=4000 %timeout=4000
Debug * Print 新浪分享影片信息
ITTImageView /var/mobile/Applications/D93D67C5-C167-4F9A-B7C0-AF6CBF24695E/Library/Caches/images/http%3A%2F%2F120.196.125.11%3A14680%2Fmovieposter%2Fimage%2Faipingbeijing9.jpg Tap left %thinktime=4000 %timeout=4000
Button "home cinema detail big(2)" Tap left %thinktime=4000 %timeout=4000
Button "share btn" Verify
Button "share btn" Tap left %thinktime=4000 %timeout=4000
Button 新浪微博分享 Tap left %thinktime=4000 %timeout=4000
Label * VerifyWildcard 新浪
Button "sina share btn" Tap left %thinktime=4000 %timeout=4000
TextArea * EnterText * %thinktime=4000 %timeout=4000
Button "Header back btn" Tap left %thinktime=4000 %timeout=4000
Button #mt Tap left %thinktime=4000 %timeout=4000