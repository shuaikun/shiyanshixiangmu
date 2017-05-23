Button "zsq tab more a" Tap %thinktime=4000 %timeout=4000
Debug * Print 进入更多设置 %thinktime=4000 %timeout=4000
Label 设置 Verify 设置 %thinktime=4000 %timeout=4000
SettingCell 分享软件 Tap %thinktime=4000 %timeout=4000
Debug * Print 选择微博分享 %thinktime=4000 %timeout=4000
Button 新浪微博分享 VerifyWildcard 新浪* %thinktime=4000 %timeout=4000
Button 新浪微博分享 Tap %thinktime=4000 %timeout=4000
Button "sina share btn" Verify %thinktime=4000 %timeout=4000
TextArea * EnterText "【深圳爱电影iPhone客户端】我正在使用一款很不错的iPhone应用：深圳爱电影。有了它，我...https://itunes.apple.com/cn/app/shen-zhen-ai-dian-ying/id554059941?mt=8 (来自深圳爱电影iPhone客户端)" %thinktime=4000 %timeout=4000
Button "sina share btn" Tap %thinktime=4000 %timeout=4000
Debug * Print 退出分享功能 %thinktime=4000 %timeout=4000
Label 设置 Verify 设置 %thinktime=4000 %timeout=4000
Button "zsq tab movie a" Tap %thinktime=4000 %timeout=4000