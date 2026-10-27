#!/bin/zsh
# Met à jour depuis l'auteur, recompile et installe Holo dans /Applications (fork batman-nmd).
set -e
cd "${0:A:h}/.."
git fetch -q upstream
git checkout -q main && git merge -q --ff-only upstream/main && git push -q origin main
git checkout -q baptiste && git rebase -q main
xcodegen generate >/dev/null
xcodebuild -project Holo.xcodeproj -scheme Holo -configuration Release \
  -derivedDataPath ~/Library/Developer/HoloDerived \
  CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY="AgentIsland Dev" DEVELOPMENT_TEAM="" ENABLE_HARDENED_RUNTIME=NO \
  build -quiet
osascript -e 'quit app "Holo"' 2>/dev/null || true
rm -rf /Applications/Holo.app
cp -R ~/Library/Developer/HoloDerived/Build/Products/Release/Holo.app /Applications/
open /Applications/Holo.app
echo "Holo à jour : $(git -C . log -1 --format='%h %s' main)"
