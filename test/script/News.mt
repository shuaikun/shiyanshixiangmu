Button "zsq blue info a" Tap %thinktime=4000 %timeout=4000
Debug * Print 切换票房信息
Button 北美票房 Verify %thinktime=4000 %timeout=4000
Button 北美票房 Tap %thinktime=4000 %timeout=4000
Button 内地票房 Verify %thinktime=4000 %timeout=4000
Button 内地票房 Tap %thinktime=4000 %timeout=4000
Debug * Print 遍历头条新闻
Button 头条新闻 Tap %thinktime=4000 %timeout=4000
Table 空列表 SelectIndex 1 %thinktime=4000 %timeout=4000
Button "Header back btn" Tap %thinktime=6000 %timeout=4000
Debug * Print 遍历电影资讯
Button 电影资讯 Tap %thinktime=4000 %timeout=4000
Table * SelectIndex 1 %thinktime=6000 %timeout=4000
Debug * Print 验证是否进入信息界面
Button "Header back btn" Verify
Button "Header back btn" Tap %thinktime=4000 %timeout=4000
Debug * Print 遍历精彩影评
Button 精彩影评 Tap %thinktime=4000 %timeout=4000
Table 空列表(2) SelectIndex 1 %thinktime=4000 %timeout=4000
Debug * Print 验证是否进入影评界面
Button "Header back btn" Verify %thinktime=4000 %timeout=4000
Button "Header back btn" Tap %thinktime=4000 %timeout=4000
Button 经典人物 Tap %thinktime=4000 %timeout=4000
Button "zsq blue hot a" Tap