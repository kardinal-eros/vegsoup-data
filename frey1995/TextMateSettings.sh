#	Preview App 623%
#	TextMate should not be running
defaults read com.macromates.TextMate fontAscentDelta
defaults read com.macromates.TextMate fontLeadingDelta

defaults write com.macromates.TextMate fontLeadingDelta -float 2.7
defaults write com.macromates.TextMate fontAscentDelta -float 2.7
