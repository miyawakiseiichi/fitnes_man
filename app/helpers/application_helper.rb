module ApplicationHelper
  def default_meta_tags
    {
      site: 'FitnesMan',
      title: 'あなたのフィットネスをサポート',
      reverse: true,
      separator: '|',
      description: 'FitnesManは、あなたのフィットネスライフをサポートするアプリです。トレーニング計画の作成、進捗管理、栄養管理など、フィットネスに必要な機能が揃っています。',
      keywords: 'フィットネス,トレーニング,筋トレ,健康管理,ワークアウト',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('icon.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
      ],
      og: {
        site_name: 'FitnesMan',
        title: 'FitnesMan - あなたのフィットネスをサポート',
        description: 'FitnesManは、あなたのフィットネスライフをサポートするアプリです。', 
        type: 'website',
        url: request.original_url,
        image: full_url_for_image('ogp_default.jpg'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@your_twitter_handle',
      }
    }
  end

  def page_meta_tags(options = {})
    default_meta_tags.deep_merge(options)
  end

  def full_url_for_image(image_name)
    if Rails.env.production?
      host = ENV['ASSET_HOST'] || 'https://fitnes-man.com'
      "#{host}#{ActionController::Base.helpers.asset_path(image_name)}"
    else
      asset_url(image_name, host: request.base_url)
    end
  end
end
