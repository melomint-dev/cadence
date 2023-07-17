import AdminContract from 0xMeloMint

transaction (songId: String, like: Int) {
    prepare(signer: AuthAccount) {
        AdminContract.addLikes(songId: songId, like: like)
    }
}