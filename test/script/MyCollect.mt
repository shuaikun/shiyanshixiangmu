Debug * Print 收藏影片功能 %thinktime=4000 %timeout=4000
ITTImageView /var/mobile/Applications/D93D67C5-C167-4F9A-B7C0-AF6CBF24695E/Library/Caches/images/http%3A%2F%2F120.196.125.11%3A14680%2Fmovieposter%2Fimage%2Fdirenjiezhishendulongwang9.jpg tap %thinktime=4000 %timeout=4000
Button "home cinema detail big(2)" Tap %thinktime=4000 %timeout=4000
Debug * Print 开始收藏影片
Button "collect btn" Verify %thinktime=4000 %timeout=4000
Button "collect btn" tap %thinktime=4000 %timeout=4000
Button "Header back btn" tap %thinktime=4000 %timeout=4000
Button #mt tap %thinktime=4000 %timeout=4000
Button "zsq tab more a" tap %thinktime=4000 %timeout=4000
Debug * Print 进入我的收藏查看收藏内容
SettingCell 我的收藏 tap %thinktime=4000 %timeout=4000
FavoritesCell * tap %thinktime=4000 %timeout=4000
Table * SelectIndex 1 %thinktime=4000 %timeout=4000
Debug * Print 取消收藏影片
Button "collected btn" Verify %thinktime=4000 %timeout=4000
Button "collected btn" tap %thinktime=4000 %timeout=4000
Button "collect btn" Verify %thinktime=4000 %timeout=4000
Debug * Print 收藏与取消收藏成功
Button "Header back btn" tap left %thinktime=4000 %timeout=4000
Button "Header back btn" tap left %thinktime=4000 %timeout=4000
Button "zsq tab movie a" tap left %thinktime=4000 %timeout=4000