// insert Data from Quotes table

/*
  CupertinoButton.filled(
          child: Text("Insert"),
          onPressed: () async {
            for(int i = 0 ; i < QuoteList.quoteList.length ; i++) {

              var response = await get(Uri.parse(QuoteList.quoteList[i]['image']));
              var bytesFromPict = response.bodyBytes;

              var quotes = Quotes(category: QuoteList.quoteList[i]['category'], quote: QuoteList.quoteList[i]['quote'], image: bytesFromPict);

              await databaseHelper.insertData(quotes);
            }
          },
        ),
        */