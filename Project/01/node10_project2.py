class Kiosk:
    def __init__(self):
        self.menu = ['Americano', 'CafeLatte', 'CafeMocha', 'ChocoLatte']
        self.price = [2000, 3000, 4000, 3500]
        self.temp = ''
        self.order_menu = []
        self.order_price = []
        self.price_sum = 0

    # 메뉴 출력 메서드
    def menu_print(self):
        # 메뉴 중 가장 긴 길이 계산
        max_length = max(len(i) for i in self.menu)

        # 상단
        print('⟝' + '-' * 30 + '⟞')
        print(f'|            메뉴판             |')
        for i in range(len(self.menu)-2):
            print('|' + ' ' * 31 + '|')
        
        # 메뉴 출력 (열 맞춤 적용)
        for i in range(len(self.menu)):
            print(f'|    {i + 1}. {self.menu[i]:<{max_length}} : {self.price[i]}원     |')

        # 하단
        for i in range(len(self.menu)-2):
            print('|' + ' ' * 31+ '|')
        print('⟝' + '-' * 30 + '⟞')

    # 주문 메서드
    def menu_select(self):
        # 초기 주문번호 값
        n = 0
        while n < 1 or n > len(self.menu):
            n = int(input('주문하실 메뉴 번호를 입력해 주세요 : '))
            if n < 1 or n > len(self.menu):
                print('잘못된 입력입니다. 다시 입력해 주세요')

        # 초기 온도 값
        t = 0
        while t != 1 and t != 2:
            t = int(input('HOT 음료는 1, ICE 음료는 2를 입력해 주세요: '))
            if t == 1:
                self.temp = 'HOT'
            elif t == 2:
                self.temp = 'ICE'
            else:
                print('1과 2 중 하나를 입력하세요.')

        self.order_menu.append(f'{self.temp} {self.menu[n-1]}')
        self.order_price.append(self.price[n-1])
        self.price_sum += self.price[n-1]

        print(f'현재 주문하신 음료 : {self.temp} {self.menu[n-1]} : {self.price[n-1]} 원')

        # 추가 주문 루프
        while n != 0:
            n = int(input('추가 주문은 음료 번호를, 지불은 0을 누르세요: '))
            if n > 0 and n <= len(self.menu):
                t = 0
                while t != 1 and t != 2:
                    t = int(input('HOT 음료는 1, ICE 음료는 2를 입력해 주세요: '))
                    if t == 1:
                        self.temp = 'HOT'
                    elif t == 2:
                        self.temp = 'ICE'
                    else:
                        print("1과 2 중 하나를 입력하세요.")
                
                self.order_menu.append(f"{self.temp} {self.menu[n-1]}")
                self.order_price.append(self.price[n-1])
                self.price_sum += self.price[n-1]
                
                print(f"추가 주문 음료: {self.temp} {self.menu[n-1]} : {self.price[n-1]}원")
                print(f"합계: {self.price_sum}원")
            elif n == 0:
                print("주문이 완료되었습니다.")
                break  # 주문 완료 후 반복문 종료
            else:
                print("없는 메뉴입니다. 다시 주문해 주세요.")

    # 주문서 출력 메서드
    def table(self):
        # 상단
        print('⟝' + '-' * 31 + '⟞')
        print(f'|            주문내역             |')
        for i in range(2):
            print('|' + ' ' * 33 + '|')
        max_length = max(len(item) for item in self.order_menu)
        for i in range(len(self.order_menu)):
            print(f'|    {i + 1}. {self.order_menu[i]:<{max_length}} : {self.order_price[i]}원    |')
        
        # 하단
        print('|' + ' ' * 33 + '|')
        print(f'|         합계 : {self.price_sum}원' + ' ' * (13 - len(str(self.price_sum))) + '  |')
        for i in range(2):
            print('|' + ' ' * 33 + '|')
        print('⟝' + '-' * 31 + '⟞')

    # 지불 메서드
    def pay(self):
        print(f'지불하실 금액은 {self.price_sum}원 입니다.')
        
        payment = 0
        while payment != 1 and payment != 2:
            payment = int(input('현금결제는 1번, 카드결제는 2번을 눌러주세요 : '))
            
            if payment == 1:
                print('직원을 호출하겠습니다.')
                break
            elif payment == 2:
                print('IC칩 방향에 맞게 카드를 꽂아주세요.')
                break
            else:
                print('다시 결제를 시도해 주세요.')


a = Kiosk()  # 객체 생성 
a.menu_print()  # 메뉴 출력
a.menu_select()  # 주문
a.pay()  # 지불 
a.table()  # 주문표 출력 
