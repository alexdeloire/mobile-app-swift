import SwiftUI

struct GameDetailView: View {
    let game: GameInfo
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !game.image_jeu.isEmpty {
                    AsyncImage(url: URL(string: game.image_jeu)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 300)
                            .clipped()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 300)
                            .clipped()
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Nom du jeu:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.nom_du_jeu)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Auteur:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.auteur)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Editeur:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.editeur)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Nombre de joueurs:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.nb_joueurs)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Âge minimum:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.age_min)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Durée:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.duree)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Type de jeu:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.type_jeu)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Notice:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.notice)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Zone plan:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.zone_plan)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Zone bénévole:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.zone_benevole)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Zone bénévole ID:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.zone_benevole_id)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("À animer:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.a_animer)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Reçu:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.recu)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Mécanismes:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.mecanismes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Thèmes:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.themes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Tags:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.tags)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Description:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(game.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(game.nom_du_jeu)
    }
}
