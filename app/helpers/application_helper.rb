module ApplicationHelper

  #ページごとの完全なタイトルをかえす。full_titleヘルパーは、ページタイトルが定義されていない場合は基本タイトル「Ruby on Rails Tutorial Sample App」を返し、定義されている場合は基本タイトルに縦棒とページタイトルを追加してかえす。
  def full_title(page_title = '')                       # メソッド定義とオプション引数
    base_title = "Ruby on Rails Tutorial Sample App"    # 変数への代入
    if page_title.empty?                                # 論理値テスト
        base_title                                      # 暗黙の戻り値
    else                                                
      "#{page_title} | #{base_title}"                   # 文字列の式展開
    end
  end
end
