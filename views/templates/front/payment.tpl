{*
 * Simplify Commerce module to start accepting payments now. It's that simple.
 *
 * Redistribution and use in source and binary forms, with or without modification, are 
 * permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of 
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of 
 * conditions and the following disclaimer in the documentation and/or other materials 
 * provided with the distribution.
 * Neither the name of the MasterCard International Incorporated nor the names of its 
 * contributors may be used to endorse or promote products derived from this software 
 * without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
 * SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER 
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
 * SUCH DAMAGE.
 *
 *  @author    MasterCard (support@simplify.com)
 *  @version   Release: 1.0.3
 *  @copyright 2014, MasterCard International Incorporated. All rights reserved. 
 *  @license   See licence.txt
 *}
<div>
<script>
    var simplifyPublicKey = "{$simplify_public_key|escape:'htmlall':'UTF-8'}",
            simplifyFirstname = "{$firstname|escape:'htmlall':'UTF-8'}", simplifyLastname = "{$lastname|escape:'htmlall':'UTF-8'}", simplifyCity = "{$city|escape:'htmlall':'UTF-8'}", simplifyAddress1 = "{$address1|escape:'htmlall':'UTF-8'}", simplifyAddress2 = "{$address2|escape:'htmlall':'UTF-8'}", simplifyState = "{$state|escape:'htmlall':'UTF-8'}", simplifyPostcode = "{$postcode|escape:'htmlall':'UTF-8'}";
</script>
<div class="simplifyFormContainer box">
<div class="clearfix">
    <h3 class="left pay-by-credit-card">Pay by Credit Card</h3>
    <img alt="Secure Icon" class="secure-icon secure-icon-img" src="{$module_dir|escape}img/secure-icon.png"/>

    <div class="error-msg">
        <span id="simplify-test-mode-msg" class="test-msg">( TEST PAYMENT )</span>
        <span id="simplify-no-keys-msg" class="msg-container hidden">Payment Form not configured correctly. Please contact support.</span>
    </div>
</div>

<div id="simplify-ajax-loader">
    <span>Your payment is being processed...</span>
    <img src="{$module_dir|escape}img/ajax-loader.gif" alt="Loader Icon"/>
</div>

<form action="{$module_dir|escape}payment.php" method="POST" id="simplify-payment-form">
{if isset($show_saved_card_details)}
    <div id="old-card-container" class='card-type-container selected clearfix'>
        <div class="simplify-payment-errors">{if isset($smarty.get.simplify_error)}{$smarty.get.simplify_error|escape:html:'UTF-8'}{/if}</div>
        <div class="first card-detail left">
            <div class='card-detail-label'>&nbsp;</div>
            <input class="left" type="radio" name='cc-type' value='old' checked='checked'/>
        </div>
        <div class="card-detail left">
            <div class='card-detail-label'>Card Type</div>
            <div class='card-detail-text'>{$customer_details->card->type|escape:'htmlall': 'UTF-8'}</div>
        </div>
        <div class="card-detail left">
            <div class='card-detail-label'>Card Number</div>
            <div class='card-detail-text'>xxxx - xxxx - xxxx
                - {$customer_details->card->last4|escape:'htmlall':'UTF-8'}</div>
        </div>
        <div class="card-detail left">
            <div class='card-detail-label'>Expiry Date</div>
            <div class='card-detail-text'>
                        <span class='left'>{$customer_details-> card->expMonth|escape:'htmlall':'UTF-8'}
                            / {$customer_details->card->expYear|escape:'htmlall':'UTF-8'}</span>

                <div id="cc-deletion-container" class="right center">
                    <div>
                        <img id='trash-icon' src="{$module_dir|escape}img/trash.png" alt="trash icon"
                             title="Delete Credit Card"/>
                    </div>
                    <div id="cc-confirm-deletion">
                        <div class='small pad-botom'>Delete Credit Card?</div>
                        <div>
                            <span id="confirm-cc-deletion">Yes</span>
                            <span id="cancel-cc-deletion">No</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <div id="cc-deletion-msg">Your credit card has been deleted: <span id="cc-undo-deletion-lnk"
                                                                       class='underline'>Undo <img
                    alt="Secure Icon" class="secure-icon" src="{$module_dir|escape}img/undo.png"/></span></div>
{/if}
<div id="new-card-container" class='card-type-container clearfix'>
    {if isset($show_saved_card_details)}
        <div class="clearfix">
            <div class="first card-detail left">
                <input class="left" type="radio" name='cc-type' value='new'
                       {if isset($smarty.get.simplify_error)}checked='checked'{/if} />
            </div>
            <div class="card-detail left">
                <div class='card-detail-text'>New Credit Card</div>
            </div>
        </div>
    {/if}
    <!-- DO NOT REMOVE THIS INLINE STYLE. It needs to be there for showing 'New Card' section displayed -->
    <div id="simplify-cc-details" {if isset($show_saved_card_details)} style="display: {if isset($smarty.get.simplify_error)}block;{else}none;{/if}"{/if} {if isset($show_saved_card_details)} class="indent"{/if}>
        <div class="simplify-payment-errors">{if isset($smarty.get.simplify_error)}{$smarty.get.simplify_error|escape:html:'UTF-8'}{/if}</div>
        <a name="simplify_error" class="hidden"></a>
        {if $payment_mode == 'hosted_payments'}
            <script type="text/javascript" src="https://www.simplify.com/commerce/simplify.pay.js"></script>
            <script type="text/javascript">
                //Hosted payments options
                var options = {
                    color: "{$overlay_color|escape:'htmlall':'UTF-8'}"
                };

                //if its non-HTTPS set the redirectUrl back to this page
                if (!document.location.href.match(/^https:\/\//)) {
                    //redirect back to payment step
                    if (!window.location.origin) { //IE don't have window.location.origin :(
                        window.location.origin = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port : '');
                    }
                    options.redirectUrl = window.location.origin + window.location.pathname;
                    console.log("Redirect url is " + options.redirectUrl);
                }

                function helper(){
                    if(typeof $ === "undefined"){
                        console.log("Waiting for jquery");
                        setTimeout(helper, 10);
                        return;
                    }

                    $(document).ready(function () {
                        var url = window.location.href;
                        var cardToken = urlParam('cardToken', url);

                        if (cardToken) {
                            console.log("has card token " + cardToken);

                            // on our way back from hosted payments
                            toggleHostedPaymentButton(false);
                            var response = {
                                cardToken: cardToken
                            };
                            processHostedPaymentForm(response, url);
                        }
                        else {
                            console.log("does not have card token");
                            initHostedPayments(options);

                            $('#simplify-hosted-payment-button').click(function () {
                                toggleHostedPaymentButton(false);

                                if (options.redirectUrl) {
                                    if ($('#saveCustomer').is(':checked')) {
                                        options.redirectUrl += '&saveCustomer=true';
                                    }
                                    if ($("#cc-deletion-msg").is(':visible')) {
                                        options.redirectUrl += '&deleteCustomerCard=true';
                                    }
                                }
                                initHostedPayments(options);
                            });
                        }
                    });
                }
                helper();

            </script>
            <div>
                <button id="simplify-hosted-payment-button"
                        data-sc-key="{$simplify_public_key|escape:'htmlall':'UTF-8'}"
                        data-name="{$hosted_payment_name|escape:'htmlall':'UTF-8'}"
                        data-description="{$hosted_payment_description|escape:'htmlall':'UTF-8'}"
                        data-reference="{$hosted_payment_reference|escape:'htmlall':'UTF-8'}"
                        data-amount="{$hosted_payment_amount}"
                        data-operation="create.token"
                        data-customer-name="{$firstname|escape:'htmlall':'UTF-8'} {$lastname|escape:'htmlall':'UTF-8'}"
                        data-color="{$overlay_color|escape:'htmlall':'UTF-8'}">
                    Pay Now
                </button
            </div>
        {else}
            <label>Card Number</label>
            <br/>
            <input type="text" size="20" autocomplete="off" class="simplify-card-number" autofocus/>
            <div>
                <div class="block-left">
                    <div class="clear"></div>
                    <label>Expiration (MM YYYY)</label>
                    <br/>

                    <div>{html_select_date display_days=false end_year='+20'|escape:'htmlall':'UTF-8'}</div>
                </div>
                <div>
                    <label>CVC</label><br/>
                    <input type="text" size="4" autocomplete="off" class="simplify-card-cvc" maxlength="4"/>
                    <a href="javascript:void(0)" class="simplify-card-cvc-info no-border">
                        What's this?
                        <div class="cvc-info">
                            The CVC (Card Validation Code) is a 3 or 4 digit code on the reverse side of Visa,
                            MasterCard and Discover cards and on the front of American Express cards.
                        </div>
                    </a>
                </div>
            </div>
        {/if}
        <br/>
        {if isset($show_save_customer_details_checkbox)}
            <div class="clearfix save-customer">
                <input type="checkbox" id="saveCustomer" name="saveCustomer">
                <span id="saveCustomerLabel">Save your credit card details securely?</span>
                <span id="updateCustomerLabel">Update your credit card details securely?</span>
            </div>
        {/if}

        {if $payment_mode != 'hosted_payments'}
            <div>
                <img alt="Secure Icon" class="payment-cards" src="{$module_dir|escape}img/credit-cards.png"/>
            </div>
        {/if}
    </div>
</div>
{if $payment_mode == 'hosted_payments'}
    <input type="hidden" name="hostedPayments" value="true"/>
{/if}
<div>
</div>
</form>
</div>
</div>
