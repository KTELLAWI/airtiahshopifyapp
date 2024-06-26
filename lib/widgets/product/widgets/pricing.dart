import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart' show AppModel, Product;
import '../../../services/service_config.dart';

class ProductPricing extends StatelessWidget {
  final Product product;
  final bool hide;
  final bool showOnlyPrice;
  final TextStyle? priceTextStyle;

  const ProductPricing({
    Key? key,
    required this.product,
    required this.hide,
    this.showOnlyPrice = false,
    this.priceTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hide) return const SizedBox();

    final currency = Provider.of<AppModel>(context, listen: false).currencyCode;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;

    var priceProduct = PriceTools.getPriceProductValue(product, onSale: true);

    /// Calculate the Sale price
    var isSale = (product.onSale ?? false) &&
        PriceTools.getPriceProductValue(product, onSale: true) !=
            PriceTools.getPriceProductValue(product, onSale: false);

    if (product.isVariableProduct) {
      isSale = product.onSale ?? false;
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      children: <Widget>[
        Text(
          product.type == 'grouped'
              ? '${S.of(context).from} ${PriceTools.getPriceProduct(
                  product,
                  currencyRate,
                  currency,
                  onSale: true,
                )}'
              : priceProduct == '0.0'
                  ? S.of(context).loading
                  : ServerConfig().isListingType
                      ? PriceTools.getCurrencyFormatted(
                          product.price ?? product.regularPrice ?? '0', null,
                          currency: currency)!
                      : PriceTools.getPriceProduct(
                          product, currencyRate, currency,
                          onSale: true)!,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(
                fontWeight: FontWeight.w800,
              )
              .apply(fontSizeFactor: 0.6)
              .merge(priceTextStyle),
        ),
        //  if (!isSale) ...[
        // const  SizedBox(height:35)
        //  ],

        /// Not show regular price for variant product (product.regularPrice = "").
        if (isSale && product.type != 'variable' && showOnlyPrice == false) ...[
          const SizedBox(width: 1),
          Text(
            product.type == 'grouped'
                ? ''
                :
                 PriceTools.getPriceProduct(product, currencyRate, currency,
                    onSale: false)!,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(
                  fontWeight: FontWeight.w300,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  decoration: TextDecoration.lineThrough,
                )
                .apply(fontSizeFactor: 0.7)
                .merge(
                  priceTextStyle?.copyWith(
                      color: priceTextStyle?.color?.withOpacity(0.6),
                      fontSize: priceTextStyle?.fontSize != null
                          ? priceTextStyle!.fontSize! - 2
                          : null),
                ),
          ),
        ],
        
      ],
    );
  }
}
