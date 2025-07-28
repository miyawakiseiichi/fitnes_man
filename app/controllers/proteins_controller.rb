class ProteinsController < ApplicationController
  before_action :authenticate_user! # ユーザー認証が必要

  def index
    @recommended_products = [
      {
        name: "ザバス プロテイン",
        description: "初心者におすすめの人気商品",
        price: "3,980",
        image: "savas.jpg",
        url: "https://www.amazon.co.jp/stores/%E3%82%B6%E3%83%90%E3%82%B9%EF%BC%88SAVAS%EF%BC%89/page/A2F2EBD8-7B69-4322-AD40-08D2D78F7BBD"
      },
      {
        name: "マイプロテイン",
        description: "コスパ最高の海外のブランド",
        price: "4,990",
        image: "myprotein.jpg",
        url: "https://www.amazon.co.jp/MyProtein-10889155-%E3%83%9E%E3%82%A4%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3-Impact-%E3%83%9B%E3%82%A8%E3%82%A4%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3-%E3%83%8A%E3%83%81%E3%83%A5%E3%83%A9%E3%83%AB%E3%83%81%E3%83%A7%E3%82%B3%E3%83%AC%E3%83%BC%E3%83%88-2-5kg/dp/B00MGPV5RE"
      },
      {
        name: "シェイクベビー",
        description: "女性に超人気甘く美味しく飲みやすい",
        price: "5,980",
        image: "shakebaby.jpg",
        url: "https://www.amazon.co.jp/Season1%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3-SHAKEBABY-Strawberry-%E3%83%80%E3%82%A4%E3%82%A8%E3%83%83%E3%83%88%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3750g%C3%97%EF%BC%92%E5%80%8B-%E3%82%B9%E3%83%95%E3%83%BC%E3%83%B31%E7%82%B9%E3%80%90%E6%97%A5%E6%9C%AC%E5%9B%BD%E5%86%85%E9%85%8D%E9%80%81%E3%80%91/dp/B08LKZXGFX"
      },
      {
        name: "バルクス",
        description: "伝説の山本先生監修      味   コスパ 文句なし",
        price: "4,480",
        image: "valx.jpg",
        url: "https://www.amazon.co.jp/VALX-%E3%83%90%E3%83%AB%E3%82%AF%E3%82%B9-%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3-%E3%83%81%E3%83%A7%E3%82%B3%E3%83%AC%E3%83%BC%E3%83%88%E9%A2%A8%E5%91%B3-Produced/dp/B08SHY7XKH"
      },
      {
        name: "ビーレジェンド",
        description: "楽天通販ランキング1位  味の種類多",
        price: "4,280",
        image: "belegend.jpg",
        url: "https://www.amazon.co.jp/%E3%83%93%E3%83%BC%E3%83%AC%E3%82%B8%E3%82%A7%E3%83%B3%E3%83%89-be-LEGEND-%E3%83%9B%E3%82%A8%E3%82%A4%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3-%E3%83%99%E3%83%AA%E3%83%99%E3%83%AA%E3%83%99%E3%83%AA%E3%83%BC%E9%A2%A8%E5%91%B3/dp/B01FRT7D4E"
      },
      {
        name: "タンパクオトメ",
        description: "全てはダイエットのために",
        price: "3,780",
        image: "tanpakuotome.jpg",
        url: "https://www.amazon.co.jp/%E3%82%BF%E3%83%9E%E3%83%81%E3%83%A3%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%97-%E3%82%BF%E3%83%B3%E3%83%91%E3%82%AF%E3%82%AA%E3%83%88%E3%83%A1-%E5%8D%9A%E5%A4%9A%E3%81%82%E3%81%BE%E3%81%8A%E3%81%86-260g-%E7%BE%8E%E5%AE%B9%E5%B0%82%E9%96%80%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3/dp/B08S71L2TR"
      },
      {
        name: "ゴールドスタンダード",
        description: "世界No.1プロテイン 高品質で信頼性抜群",
        price: "6,980",
        image: "goldstandard.jpg",
        url: "https://www.amazon.co.jp/Standard-%E3%83%80%E3%83%96%E3%83%AB%E3%83%AA%E3%83%83%E3%83%81%E3%83%81%E3%83%A7%E3%82%B3%E3%83%AC%E3%83%BC%E3%83%88-%E3%82%AA%E3%83%97%E3%83%86%E3%82%A3%E3%83%9E%E3%83%A0%E3%83%8B%E3%83%A5%E3%83%BC%E3%83%88%E3%83%AA%E3%82%B7%E3%83%A7%E3%83%B3-Optimum-Nutrition/dp/B0DMFLV4B1/ref=sr_1_1_sspa?adgrpid=127782996949&dib=eyJ2IjoiMSJ9.SVYuKHD3JwpDcl5LgsV7_myk8w4Jtd4bvD5sEbGvAYS-6FslEOoPhsJZTkQaUS7JQfrGkeupxxO25eSSJBJxKHWLNPWBX72C_wwZa0xJqTG0mb7tLVX5q0ifr6wJ0D96g3wpAcHJ7Ij--jv37crxRSd8S3Sj_VtyHh-odfa6IbzHjd8Ruy5kv9n24Ca9Q2E33qMjhAeNGOUUygxqost6Q-YmbZPDkfo1xLpglkSy-W2G1TzbLSzM7UHuKZGy9PscMZC_-qv5woNCh4VJafrzsX-ZXC95OCTBpVLatri20V0.Wf0v86wYFAShKG_fB1xmxybHyvGFr4rXGYXm-qsGXP4&dib_tag=se&hvadid=658918471568&hvdev=c&hvlocphy=1009311&hvnetw=g&hvqmt=e&hvrand=10308917137511437688&hvtargid=kwd-297456953168&hydadcr=29047_14730526&jp-ad-ap=0&keywords=%E3%82%B4%E3%83%BC%E3%83%AB%E3%83%89%2B%E3%82%B9%E3%82%BF%E3%83%B3%E3%83%80%E3%83%BC%E3%83%89&mcid=d2e82ffd6716333d9eb0792697eb269a&qid=1748282189&s=hpc&sr=1-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&th=1"
      },
      {
        name: "DNS プロテイン",
        description: "アスリート向け 高品質な国産ブランド",
        price: "4,580",
        image: "dns.jpg",
        url: "https://www.amazon.co.jp/DNS-%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3-%E3%83%9B%E3%82%A8%E3%82%A4100-%E3%83%88%E3%83%AD%E3%83%94%E3%82%AB%E3%83%AB%E3%83%9E%E3%83%B3%E3%82%B4%E3%83%BC%E9%A2%A8%E5%91%B3-%E3%83%9B%E3%82%A8%E3%82%A4%E3%81%9F%E3%82%93%E3%81%B1%E3%81%8F%E8%B3%AA/dp/B0BVYN9RST/ref=sr_1_1_sspa?crid=ZFGR2RI5OLX1&dib=eyJ2IjoiMSJ9.b0rLM1nFR3JLxgNdnm8iAVynN3ZrAJvtC_zEQ03KMPD6czD8ZrcCuIXsUq4bMN7wMV84rq_TWFOBdx-_bXAoYnjgkBjLWGAYC_iAGnzPKM9PIw3ynJA5_UTkuC94HikJYJSslm2VtdHGrWt9ixwkIpdldC_mcycT-Or_mhPf6_VN1weVt5TNV_gAZFK_vXJ3yTtF0yxkzRKrs5TkKOWAt7i-ESqhSmZy_MZJt9FQdpINopW5rslt7-JWQt0UIMvq36eIGxguFaxCMMbd_UJRe569-waDvYOcOCX8s_QvrJo.OlM4BrqGlYCYPT5ouZN5_V95nbNC_OMNZVxtapWk97A&dib_tag=se&keywords=dns+%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3&qid=1748282224&s=hpc&sprefix=DNS%2Chpc%2C201&sr=1-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1"
      },
      {
        name: "ソイプロテイン",
        description: "植物性100% 乳製品不使用で安心",
        price: "3,280",
        image: "soy.jpg",
        url: "https://www.amazon.co.jp/REYS-%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3-%E3%83%93%E3%82%BF%E3%83%9F%E3%83%B37%E7%A8%AE%E9%85%8D%E5%90%88-%E3%82%BD%E3%82%A4%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3-%E3%83%81%E3%83%A7%E3%82%B3%E3%83%AC%E3%83%BC%E3%83%88%E9%A2%A8%E5%91%B3/dp/B0D4TNQ385/ref=sr_1_3_sspa?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&crid=32QHX8RS281OR&dib=eyJ2IjoiMSJ9.gScGzdNvF0XvS6pUwLXNrKTPmBNNSpH7AurzDK1jSHP5fWMdaCmyMXjCRdV7FAU5Blxq9UFiHclJiYxZVZdZBE-LpvTBe7wSRolw243UqGvTdXYa0w4tK_p2rRxprbvml9ENbSIf2XK4_8Fqs32GxFDtspzLPksNnE_9ir6N5So2cgnUeNilMbljQaGlarlSI4ahIlnNugxzLctt3HzPUTv3PRCjlNVnImgXDs482WUn9p-Nd0Q6Tn3_2bRRErkxa8a0OPqZXFk4L41EgU3oMOQVdt9TKqtGN_pJrKiSga0.vHeSDnj6JcQnQ6DqCNbaR9-oip7hwS5xXeuwsL0fQB8&dib_tag=se&keywords=%E3%82%BD%E3%82%A4%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3&qid=1748282263&s=hpc&sprefix=%E3%82%BD%E3%82%A4%E3%83%97%E3%83%AD%E3%83%86%E3%82%A4%E3%83%B3%2Chpc%2C181&sr=1-3-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&th=1"
      }
    ]

    @search_results = []
    if params[:search].present?
      search_term = params[:search].downcase
      @search_results = @recommended_products.select do |product|
        product[:name].downcase.include?(search_term) ||
        product[:description].downcase.include?(search_term)
      end
    end
  end
end
