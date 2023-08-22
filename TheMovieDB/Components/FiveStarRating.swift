import SwiftUI


public struct FiveStarView: View {
    var rating: Decimal
    var color: Color
    var backgroundColor: Color
    var fillStar: Bool

    public init(
        rating: Decimal,
        color: Color = .yellow,
        backgroundColor: Color = .yellow,
        fillStar: Bool = false
    ) {
        self.rating = rating
        self.color = color
        self.backgroundColor = backgroundColor
        self.fillStar = fillStar
    }


    public var body: some View {
        ZStack {
            BackgroundStars(backgroundColor, fillStar: fillStar)
            ForegroundStars(rating: rating, color: color)
        }
    }
}


struct RatingStar: View {
    var rating: CGFloat
    var color: Color
    var index: Int
    
    
    var maskRatio: CGFloat {
        let mask = rating - CGFloat(index)
        
        switch mask {
        case 1...: return 1
        case ..<0: return 0
        default: return mask
        }
    }


    init(rating: Decimal, color: Color, index: Int) {
        
        self.rating = CGFloat(Double(rating.description) ?? 0)
        self.color = color
        self.index = index
    }


    var body: some View {
        GeometryReader { star in
            StarImage()
                .foregroundColor(self.color)
                .mask(
                    Rectangle()
                        .size(
                            width: star.size.width * self.maskRatio,
                            height: star.size.height
                        )
                    
                )
        }
    }
}


private struct StarImage: View {

    let fill: Bool
    
    init(fill: Bool = true) {
        self.fill = fill
    }

    var body: some View {
        Image(systemName: fill ? "star.fill" : "star")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}


private struct BackgroundStars: View {
    var color: Color
    var fillStar: Bool

    init(_ color: Color, fillStar: Bool) {
        self.color = color
        self.fillStar = fillStar
    }


    var body: some View {
        HStack {
            ForEach(0..<5) { _ in
                StarImage(fill: fillStar)
            }
        }.foregroundColor(color)
    }
}


private struct ForegroundStars: View {
    var rating: Decimal
    var color: Color


    init(rating: Decimal, color: Color) {
        self.rating = rating
        self.color = color
    }


    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                RatingStar(
                    rating: self.rating,
                    color: self.color,
                    index: index
                )
            }
        }
    }
}


struct FiveStarView_Previews: PreviewProvider {


    static var previews: some View {
        VStack {
            FiveStarView(rating: 3.3)
                .frame(minWidth: 1, idealWidth: 100, maxWidth: 150, minHeight: 1, idealHeight: 30, maxHeight: 50, alignment: .center)
                .previewDevice("iPhone 11")
        }
    }
}

