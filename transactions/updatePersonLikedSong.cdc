import MeloMint from 0xMeloMint

transaction(songId: String) {
    prepare(signer: AuthAccount) {
        MeloMint.changePersonLikedSongs(person: signer, songId: songId)
    }
}