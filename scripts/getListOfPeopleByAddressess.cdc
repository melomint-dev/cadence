import MeloMint from 0xMeloMint

pub fun main(personIds: [Address]): [MeloMint.Person] {
    let arrayOfPerson: [MeloMint.Person] = [] 

    for personId in personIds {
        arrayOfPerson.append(MeloMint.getPersonByAddress(id: personId)) 
    }

    return arrayOfPerson
}