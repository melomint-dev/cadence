import MeloMint from 0xMeloMint

transaction (newType: Int) {
    prepare(signer: AuthAccount) {
        MeloMint.changePersonType(person: signer, newType: newType)
    }
}