import MeloMint from 0x01

transaction(songId: String) {
    prepare(signer: AuthAccount) {
        MeloMint.addRecentlyHeard(person: signer, songId: songId)
    }
}