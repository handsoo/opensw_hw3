declare -A AREA_CODES=(
["02"]="서울"
["031"]="경기"
["032"]="인천"
["051"]="부산"
["052"]="대구"
)

if [ "$#" -ne 2 ]; then
    echo "사용법: $0 <이름> <전화번호>"
    exit 1
fi

NAME=$1
PHONE=$2

if ! [[ "$PHONE" =~ ^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$ ]]; then
  echo "전화번호는 올바른 형식이 아닙니다. 예: 02-2222-2222"
  exit 1
fi

AREA_CODES=$(echo "$PHONE" | cut -d'-' -f1)

if[ -z "${AREA_CODES[$AREA_CODES]}" ]; then
  echo "알 수 없는 지역번호입니다: $AREA_CODE"
  exit 1
fi

AREA=${AREA_CODES[$AREA_CODE]}

PHONEBOOK="phonebook.txt"

if [ ! -f "$PHONEBOOK" ]; then
   touch "$PHONEBOOK"
fi

EXISTING_ENTRY=$(grep "^$NAME" "$PHONEBOOK")

if [ -n "$EXISTING_ENTRY" ]; then
   EXISTING_PHONE=$(echo "$EXISTING_ENTRY" | awk '{print $2}')
   if [ "$EXISTING_PHONE" == "$PHONE" ]; then
      echo "같은 전화번호가 이미 존재합니다."
      exit 0
   else 
      echo "전화보호가 다릅니다. 새로운 전화번호로 업데이트합니다."
      sed -i "/^$NAME /d" "$PHONEBOOK"
   fi
fi

echo "$NAME $PHONE $AREA" >> "$PHONEBOOK"

sort -o "$PHONEBOOK" "$PHONEBOOK"

echo "전화번호부가 업데이트되었습니다."