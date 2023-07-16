import MeloMint from 0xMeloMint

transaction(id: String, name: String, freeUrl: String, img: String, bannerImg: String) {
  prepare(signer: AuthAccount) {
    MeloMint.newSong(id: id, name: name, artist: signer.address, freeUrl: freeUrl, img: img, bannerImg: bannerImg)
  }

  execute {
    log(MeloMint.getSongs())
  }
}