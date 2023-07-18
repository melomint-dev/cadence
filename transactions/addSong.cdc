import MeloMint from 0xMeloMint

transaction(id: String, name: String, freeUrl: String, img: String, duration: UFix64, preRelease: UFix64) {
  prepare(signer: AuthAccount) {
    MeloMint.newSong(id: id, name: name, artist: signer, img: img, freeUrl: freeUrl, duration: duration, preRelease: preRelease)
  }

  execute {
    log(MeloMint.getSongs())
  }
}