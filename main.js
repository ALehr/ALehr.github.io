// handle two column layout on 1000px breakpoint
const centerColumns = () => {

    const $MAIN = document.querySelector('main');

    // verify breakpoint width
    if (document.querySelector('html').clientWidth >= 1000) {
        
        // calculate width of body - left and right padding
        const $BODY = document.querySelector('body');
        const getBodyWidth = () => {
            const BODY_STYLES = getComputedStyle($BODY);
            let bodyWidth = $BODY.clientWidth;
            bodyWidth -= parseFloat(BODY_STYLES.paddingLeft) + parseFloat(BODY_STYLES.paddingRight);
            return bodyWidth;
        }

        // multiply width of main by 2 and add 1em for the flex gap
        const calcColumnsWidth = () => {
            const MAIN_STYLES = getComputedStyle($MAIN);
            const mainWidth = $MAIN.clientWidth;
            const columnsWidth = (mainWidth * 2) + parseFloat(MAIN_STYLES.gap);
            return columnsWidth;
        }

        // set main left margin to half of bodyWidth - columnsWidth
        const mainLeftMargin = (getBodyWidth() - calcColumnsWidth()) / 2;
        $MAIN.style.marginLeft = `${mainLeftMargin}px`;

    } else {
        $MAIN.style.marginLeft = 'auto';
    }
}

window.addEventListener('DOMContentLoaded', centerColumns);
window.addEventListener('resize', centerColumns);