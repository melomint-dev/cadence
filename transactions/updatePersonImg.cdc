import MeloMint from 0xMeloMint

transaction(img: String) {
    prepare(signer: AuthAccount) {
        MeloMint.updatePersonImage(person: signer, img: img)
    }
}